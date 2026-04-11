# update_bib.R
# Run standalone from the Positron R console to check for new publications
# and metadata updates from Google Scholar and ORCID.
#
# Fetches from both sources, compares against publications.bib, and prints a
# review report.  Does NOT auto-modify publications.bib — all edits are manual.
#
# Usage:
#   source("update_bib.R")          # prints report to console
#   source("update_bib.R"); writeLines(report, "bib_review.txt")  # also saves
#
# Requires:
#   install.packages(c("scholar", "rorcid", "RefManageR",
#                      "dplyr", "stringr", "purrr", "tibble", "glue"))

suppressPackageStartupMessages({
  library(scholar)
  library(rorcid)
  library(RefManageR)
  library(dplyr)
  library(stringr)
  library(purrr)
  library(tibble)
  library(glue)
})

.scholar_id <- "AcbJlasAAAAJ"
.orcid_id   <- "0000-0002-0277-4064"
.bib_file   <- "publications.bib"

# ── Helpers ───────────────────────────────────────────────────────────────────

# Strip punctuation/case for fuzzy title matching
norm_title <- function(x) {
  str_to_lower(x) |>
    str_replace_all("[^a-z0-9 ]", " ") |>
    str_squish()
}

# Check whether two normalised titles are "probably the same paper".
# Uses a word-overlap ratio — robust to minor subtitle differences.
titles_match <- function(a, b, threshold = 0.70) {
  words_a <- str_split(a, " ")[[1]]
  words_b <- str_split(b, " ")[[1]]
  if (length(words_a) == 0 || length(words_b) == 0) return(FALSE)
  overlap  <- sum(words_a %in% words_b)
  min_len  <- min(length(words_a), length(words_b))
  (overlap / min_len) >= threshold
}

# Find the bib key of the best-matching entry for a given title.
# Returns NA_character_ if no entry meets the threshold.
find_bib_match <- function(query_title_norm, bib_titles_norm, keys,
                           threshold = 0.70) {
  scores <- map_dbl(bib_titles_norm, \(bt) {
    words_q <- str_split(query_title_norm, " ")[[1]]
    words_b <- str_split(bt, " ")[[1]]
    if (length(words_q) == 0 || length(words_b) == 0) return(0)
    overlap <- sum(words_q %in% words_b)
    min_len <- min(length(words_q), length(words_b))
    overlap / min_len
  })
  best_idx <- which.max(scores)
  if (scores[best_idx] >= threshold) keys[best_idx] else NA_character_
}

# ── 1. Load existing bib ──────────────────────────────────────────────────────

message("Reading ", .bib_file, " ...")
bib <- RefManageR::ReadBib(.bib_file, check = FALSE)

bib_df <- map_dfr(names(bib), \(k) {
  e <- bib[[k]]
  tibble(
    key     = k,
    title   = as.character(e$title   %||% ""),
    journal = as.character(e$journal %||% ""),
    year    = as.character(e$year    %||% ""),
    volume  = as.character(e$volume  %||% ""),
    number  = as.character(e$number  %||% ""),
    pages   = as.character(e$pages   %||% ""),
    doi     = tolower(as.character(e$doi %||% "")),
    note    = as.character(e$note    %||% "")
  )
}) |>
  mutate(title_norm = norm_title(title))

bib_keys        <- bib_df$key
bib_titles_norm <- bib_df$title_norm

# ── 2. Fetch Google Scholar publications ──────────────────────────────────────

message("Fetching Google Scholar publications ...")
scholar_raw <- tryCatch(
  scholar::get_publications(.scholar_id),
  error = function(e) {
    message("  ⚠  Scholar fetch failed: ", conditionMessage(e))
    NULL
  }
)

# ── 3. Fetch ORCID works ──────────────────────────────────────────────────────

message("Fetching ORCID works ...")
orcid_raw <- tryCatch(
  rorcid::orcid_works(.orcid_id),
  error = function(e) {
    message("  ⚠  ORCID fetch failed: ", conditionMessage(e))
    NULL
  }
)

# ── 4. Parse ORCID into a tidy tibble ─────────────────────────────────────────

parse_orcid_works <- function(raw) {
  if (is.null(raw)) return(NULL)
  tryCatch({
    # orcid_works() returns a named list; first element is the person's data.
    works <- raw[[1]]$works
    if (is.null(works) || nrow(works) == 0) return(NULL)

    # Extract titles ──────────────────────────────────────────────────────────
    titles <- works[["work.title.title.value"]]
    if (is.null(titles)) {
      # Alternate column name in some API versions
      titles_col <- grep("title\\.value$", names(works), value = TRUE)[1]
      titles <- if (!is.na(titles_col)) works[[titles_col]] else rep(NA_character_, nrow(works))
    }

    # Extract years ───────────────────────────────────────────────────────────
    year_col <- grep("publication.date.year.value|published.year", names(works), value = TRUE)[1]
    years <- if (!is.na(year_col)) works[[year_col]] else rep(NA_character_, nrow(works))

    # Extract journals ────────────────────────────────────────────────────────
    journal_col <- grep("journal.title.value", names(works), value = TRUE)[1]
    journals <- if (!is.na(journal_col)) works[[journal_col]] else rep(NA_character_, nrow(works))

    # Extract DOIs from nested external-ids list column ───────────────────────
    ext_col <- grep("external.id$", names(works), value = TRUE)[1]
    if (is.na(ext_col)) ext_col <- grep("external-id$", names(works), value = TRUE)[1]
    dois <- if (!is.na(ext_col)) {
      map_chr(works[[ext_col]], \(x) {
        if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) return(NA_character_)
        # Column names vary: "external-id-type" or "external.id.type"
        type_col  <- grep("id.type$",  names(x), value = TRUE)[1]
        value_col <- grep("id.value$", names(x), value = TRUE)[1]
        if (is.na(type_col) || is.na(value_col)) return(NA_character_)
        doi_rows <- x[x[[type_col]] == "doi", , drop = FALSE]
        if (nrow(doi_rows) == 0) return(NA_character_)
        tolower(doi_rows[[value_col]][1])
      })
    } else {
      rep(NA_character_, nrow(works))
    }

    tibble(
      title      = as.character(titles),
      year       = as.character(years),
      journal    = as.character(journals),
      doi        = dois,
      title_norm = norm_title(as.character(titles))
    ) |>
      filter(!is.na(title), title != "")
  }, error = function(e) {
    message("  ⚠  Could not parse ORCID response: ", conditionMessage(e))
    message("     Column names available: ",
            paste(names(raw[[1]]$works %||% list()), collapse = ", "))
    NULL
  })
}

orcid_df <- parse_orcid_works(orcid_raw)

# ── 5. Build the report ───────────────────────────────────────────────────────

lines <- character(0)
add   <- function(...) lines <<- c(lines, glue(...))
hr    <- function(char = "─", width = 60) add(paste(rep(char, width), collapse = ""))

hr("═")
add(" UPDATE_BIB REVIEW REPORT — {format(Sys.Date(), '%Y-%m-%d')}")
hr("═")
add("")
add("  Bib file : {.bib_file}  ({nrow(bib_df)} entries)")
add("  Scholar  : {if (!is.null(scholar_raw)) nrow(scholar_raw) else 'fetch failed'} publications")
add("  ORCID    : {if (!is.null(orcid_df)) nrow(orcid_df) else 'fetch failed'} works")
add("")

# ── 5a. Scholar: unmatched entries ─────────────────────────────────────────

hr()
add(" SECTION 1 — Scholar publications not matched in bib")
hr()
add("")

if (is.null(scholar_raw)) {
  add("  (Scholar fetch failed — skipping)")
  add("")
} else {
  scholar_df <- scholar_raw |>
    as_tibble() |>
    mutate(title_norm = norm_title(title))

  scholar_unmatched <- scholar_df |>
    filter(map_lgl(title_norm, \(t) {
      is.na(find_bib_match(t, bib_titles_norm, bib_keys))
    }))

  if (nrow(scholar_unmatched) == 0) {
    add("  ✓ All Scholar publications matched in bib.")
    add("")
  } else {
    add("  {nrow(scholar_unmatched)} unmatched paper(s) — may be new publications:")
    add("")
    walk(seq_len(nrow(scholar_unmatched)), \(i) {
      p <- scholar_unmatched[i, ]
      add("  [{i}] {p$title}")
      add("       Authors : {p$author}")
      add("       Journal : {p$journal}  ({p$year})")
      add("       Scholar : https://scholar.google.com/scholar?cites={p$cid}")
      add("")
    })
  }

  # ── 5b. Scholar: year discrepancies ─────────────────────────────────────────

  hr()
  add(" SECTION 2 — Year discrepancies (bib vs Scholar)")
  hr()
  add("")

  year_issues <- bib_df |>
    mutate(
      scholar_key = map_chr(title_norm, \(t) {
        find_bib_match(t, scholar_df$title_norm, scholar_df$title)
      }),
      scholar_year = map_chr(scholar_key, \(st) {
        if (is.na(st)) return(NA_character_)
        idx <- which(scholar_df$title == st)
        if (length(idx) == 0) return(NA_character_)
        as.character(scholar_df$year[idx[1]])
      })
    ) |>
    filter(
      !is.na(scholar_year),
      !is.na(year),
      year != scholar_year
    )

  if (nrow(year_issues) == 0) {
    add("  ✓ No year discrepancies detected.")
    add("")
  } else {
    walk(seq_len(nrow(year_issues)), \(i) {
      p <- year_issues[i, ]
      add("  [{p$key}]")
      add("    bib year     : {p$year}")
      add("    Scholar year : {p$scholar_year}")
      add("    Title        : {p$title}")
      add("")
    })
  }
}

# ── 5c. ORCID: unmatched entries ─────────────────────────────────────────────

hr()
add(" SECTION 3 — ORCID works not matched in bib")
hr()
add("")

if (is.null(orcid_df)) {
  add("  (ORCID fetch failed or returned no works — skipping)")
  add("")
} else {
  # Match by DOI first, then title
  orcid_unmatched <- orcid_df |>
    filter(map_lgl(seq_len(n()), \(i) {
      row <- orcid_df[i, ]

      # DOI match: check if any bib entry shares this DOI
      if (!is.na(row$doi) && row$doi != "") {
        doi_hit <- any(bib_df$doi == row$doi, na.rm = TRUE)
        if (doi_hit) return(FALSE)  # matched
      }

      # Title match
      is.na(find_bib_match(row$title_norm, bib_titles_norm, bib_keys))
    }))

  if (nrow(orcid_unmatched) == 0) {
    add("  ✓ All ORCID works matched in bib.")
    add("")
  } else {
    add("  {nrow(orcid_unmatched)} unmatched work(s):")
    add("")
    walk(seq_len(nrow(orcid_unmatched)), \(i) {
      p <- orcid_unmatched[i, ]
      add("  [{i}] {p$title}")
      add("       Journal : {p$journal %||% '(unknown)'}  ({p$year %||% '?'})")
      if (!is.na(p$doi) && p$doi != "")
        add("       DOI     : https://doi.org/{p$doi}")
      add("")
    })
  }

  # ── 5d. ORCID: DOI enrichment opportunities ────────────────────────────────

  hr()
  add(" SECTION 4 — DOI enrichment: ORCID has DOI but bib entry has none")
  hr()
  add("")

  doi_opportunities <- orcid_df |>
    filter(!is.na(doi), doi != "") |>
    mutate(
      bib_key = map_chr(title_norm, \(t)
        find_bib_match(t, bib_titles_norm, bib_keys)
      )
    ) |>
    filter(!is.na(bib_key)) |>
    left_join(bib_df |> select(key, bib_doi = doi), by = c("bib_key" = "key")) |>
    filter(is.na(bib_doi) | bib_doi == "")

  if (nrow(doi_opportunities) == 0) {
    add("  ✓ No missing DOIs found (or no DOI data in ORCID).")
    add("")
  } else {
    add("  {nrow(doi_opportunities)} bib entries could gain a DOI:")
    add("")
    walk(seq_len(nrow(doi_opportunities)), \(i) {
      p <- doi_opportunities[i, ]
      add("  [{p$bib_key}]")
      add("    doi = \"{p$doi}\",")
      add("    Title : {p$title}")
      add("")
    })
  }
}

# ── 5e. Bib entries with no vol/issue/pages ─────────────────────────────────

hr()
add(" SECTION 5 — Bib entries missing vol / issue / pages")
hr()
add("")

incomplete <- bib_df |>
  filter(volume == "" | pages == "") |>
  filter(!str_detect(note, "(?i)online|in press|accepted"))

if (nrow(incomplete) == 0) {
  add("  ✓ All entries have volume/pages (or are marked as online-first).")
  add("")
} else {
  add("  {nrow(incomplete)} entries with incomplete bibliographic details:")
  add("")
  walk(seq_len(nrow(incomplete)), \(i) {
    p <- incomplete[i, ]
    missing <- c(
      if (p$volume == "") "volume",
      if (p$number == "") "number",
      if (p$pages  == "") "pages",
      if (p$doi    == "") "doi"
    )
    add("  [{p$key}]  missing: {paste(missing, collapse = ', ')}")
    add("    {p$title} ({p$year})")
    add("")
  })
}

# ── 6. Footer ─────────────────────────────────────────────────────────────────

hr("═")
add(" Review complete.  Edit publications.bib manually as needed.")
add(" Rerun this script after updates to confirm all issues resolved.")
hr("═")
add("")

# ── 7. Print & optionally save ────────────────────────────────────────────────

report <- lines
cat(paste(report, collapse = "\n"))
invisible(report)

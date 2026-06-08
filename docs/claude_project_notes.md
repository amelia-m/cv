# Claude Project Notes — CV repo

Working notes for Claude instances. Complements CLAUDE.md (which has the
operational basics: render commands, profiles, architecture, quirks).
Last reviewed: 2026-06-05.

## Mental model

One-directional data flow, no circular deps:

- `R/cv_data.R` — every non-bib section as a tribble. Sourced fresh by
  `cv.qmd` setup chunk in a clean env per render (render.R passes
  `envir = new.env(parent = globalenv())`).
- `bib/publications.bib` + `bib/presentations.bib` — authoritative for
  refereed articles and presentations. Rendered via
  `vitae::bibliography_entries()`, sorted `desc(issued)`.
- `cv.qmd` — layout only. Section visibility = YAML `params$show_*`;
  profiles in `R/render.R` override params. Conditional section headers
  use inline `` `r if (params$...) "# Header"` `` — keep header text and
  chunk `eval=` conditions in sync when adding sections.
- `R/update_bib.R` — read-only audit (Scholar + ORCID vs. local sources).
  Never writes to .bib. Saves dated report to `bib-reviews/`.
- `R/bib_ignore.R` — allowlists for persistent false positives.

Content edits go to `docs/Miramonti_CV_2026-03-04.md` (source of record)
FIRST, then propagate to `cv_data.R` / `.bib`.

## Things that bite

1. **Never `quarto render`** — vitae needs the rmarkdown pipeline. A stray
   `cv.html` + `cv_files/` in repo root means someone ran Quarto; both are
   artifacts, safe to delete. (`cv.html` is NOT gitignored as of
   2026-06-05; `cv_files/` is covered by `*_files/`.)
2. **vitae template patch** — lives in the *installed package*
   (`win-library/4.5/vitae/.../classic/main.tex`), silently overwritten on
   package update. `render.R::check_vitae_patch()` warns if markers are
   missing. Patch recipe in README.
3. **Scholar fetch silently returns 0 rows** when Google blocks the
   scraper (happened 2026-06-05: "Scholar: 0 publications" but Section 1
   shows "✓ all matched"). Fixed 2026-06-05: update_bib.R now treats a
   0-row Scholar result as a failed fetch. Still distrust any report where
   the Scholar count is far below ~63 (count as of 2026-05). Same risk
   remains in cv.qmd's live citation-metrics fetch (get_profile).
4. **IDs are duplicated** — Scholar ID (`AcbJlasAAAAJ`) and ORCID
   (`0000-0002-0277-4064`) are hardcoded in cv.qmd YAML, cv.qmd setup
   chunk, and update_bib.R. Change all three together.
5. **Hardcoded metric fallbacks** in cv.qmd setup chunk (`.cites`,
   `.hindex`, `.i10`, `.metrics_date`) must be hand-updated after any
   successful online render.
6. **tribble column alignment** in cv_data.R — long rows wrap, so one
   logical row spans several physical lines. Count commas carefully;
   a misplaced comma shifts every subsequent cell. Render after any edit.
7. **`manuscripts_data` is deliberately NOT in update_bib.R's known-titles
   pool** (only `preprints_data` is). update_bib.R Section 6 (added
   2026-06-05) audits the manuscript pipeline: rows with `status_date`
   NA or >60 days old get NEEDS STATUS CHECK; titles that fuzzy-match a
   fetched Scholar/ORCID work get PROMOTION CANDIDATE (add to
   publications.bib, delete the row). manuscripts_data columns
   journal/submitted/status_date/notes are internal-only; `journal`
   renders only when the `show_manuscript_journals` param is TRUE
   (default false; no profile enables it). When verifying a status,
   update `status_date` even if the status itself didn't change.
8. **fancyhdr + needspace header-includes** in cv.qmd are load-bearing
   layout fixes (running-header suppression, widowed-heading prevention).
   Don't remove.
9. **`.httr-oauth`** in repo root is an ORCID/Google OAuth token cache —
   gitignored, never commit, never print.

## Conventions

- R style: tidyverse, native pipe `|>`, snake_case, `conflicted` with
  `conflicts_prefer(dplyr::filter, dplyr::select)` in any file that loads
  dplyr. Air-style formatting.
- bib keys: `firstauthorYEARkeyword` (e.g., `mckay2020proagility`).
- "Published online …" goes in `note`; Section 5 of update_bib skips
  vol/pages checks for entries whose note matches `online|in press|accepted`.
- Author bolding (`\textbf{Miramonti}`) happens in cv.qmd's publications
  chunk via `mutate(author = map(...))` — not in the .bib files.
- bib-review findings → decisions logged in
  `bib-reviews/bib_review_notes.md`; reports themselves are gitignored.
- Release process: tag `v*` with PDF attached; open items blocking v1.0.0
  are in `docs/Miramonti_CV_review_notes.md` and README "Open items".

## State as of 2026-06-05

- Large uncommitted working-tree diff across nearly all tracked files
  (real changes — render.R rewrite, data updates). Needs commit triage.
- publications.bib: 31 entries; presentations.bib: 57.
- v1.0.0 blockers still open (see review notes doc).
- Latest bib review (2026-06-05) is unreliable on the Scholar side (0-row
  fetch, see "Things that bite" #3); ORCID side was clean.
- Manuscript-pipeline tracking (update_bib.R Section 6 + extended
  manuscripts_data) implemented 2026-06-05 but NOT yet run/verified in R,
  and Amelia's new under-review manuscripts are NOT yet entered. To-dos
  and unimplemented robustness suggestions:
  `docs/session_notes_2026-06-05.md`.

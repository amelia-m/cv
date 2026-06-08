# render.R — Render CV variants from a single cv.qmd source
#
# Usage:
#   Rscript R/render.R                        # full academic CV (default)
#   Rscript R/render.R faculty                # faculty application (no manuscripts in progress)
#   Rscript R/render.R industry               # non-academic (trimmed)
#   Rscript R/render.R coursework             # full CV + graduate coursework supplement
#   Rscript R/render.R coursework-only        # standalone coursework listing
#   Rscript R/render.R all                    # render every profile + summary
#   Rscript R/render.R full --dated           # cv_2026-05-04.pdf
#   Rscript R/render.R full --quiet           # suppress LaTeX progress output
#   Rscript R/render.R full --latex=system    # use MiKTeX/TeX Live instead of TinyTeX
#
# Or source() interactively and call:
#   render_cv("faculty")                      # after source("R/render.R")
#   render_cv(latex = "system")               # force system LaTeX (MiKTeX/TeX Live)
#
# Requires internet access to fetch live citation metrics from Google Scholar.
# If Scholar is unreachable, falls back to the last-known values hardcoded
# in the setup chunk of cv.qmd — update those after any offline render.

library(rmarkdown)

# ------------------------------------------------------------------
# Named profiles — each is a list of param overrides
# Any param not listed inherits the cv.qmd YAML default (TRUE/FALSE)
# ------------------------------------------------------------------

profiles <- list(
  # Full academic CV — all defaults (everything on, coursework off)
  full = list(),

  # Faculty job application — drop manuscripts in progress
  faculty = list(
    show_manuscripts = FALSE
  ),

  # Industry / non-academic — lean version
  industry = list(
    show_manuscripts = FALSE,
    show_preprints = FALSE,
    show_presentations = FALSE,
    show_training = FALSE,
    show_mentoring = FALSE,
    show_lab_skills = FALSE,
    show_languages = FALSE,
    show_profiles = FALSE,
    show_credentials = FALSE
  ),

  # Full CV with coursework appended
  coursework = list(
    show_coursework = TRUE,
    coursework_detail = "full"
  ),

  # Coursework summary only (area counts)
  `coursework-summary` = list(
    show_coursework = TRUE,
    coursework_detail = "summary"
  ),

  # Standalone coursework supplement — everything else off
  `coursework-only` = list(
    show_manuscripts = FALSE,
    show_preprints = FALSE,
    show_presentations = FALSE,
    show_training = FALSE,
    show_mentoring = FALSE,
    show_lab_skills = FALSE,
    show_languages = FALSE,
    show_profiles = FALSE,
    show_credentials = FALSE,
    show_coursework = TRUE,
    coursework_detail = "both"
  )
)

# ------------------------------------------------------------------
# LaTeX engine detection
# ------------------------------------------------------------------
# Detects available TeX distributions and configures the R session so
# rmarkdown uses the right one.  The tinytex R package intercepts LaTeX
# compilation when TinyTeX is installed; passing latex = "system" disables
# that intercept so the PATH pdflatex (MiKTeX, TeX Live, …) is used instead.

setup_latex <- function(latex = c("auto", "tinytex", "system")) {
  latex <- match.arg(latex)

  has_tinytex <- isTRUE(tryCatch(tinytex::is_tinytex(), error = function(e) FALSE))
  sys_pdf     <- unname(Sys.which("pdflatex"))

  engine <- switch(latex,
    auto = {
      if (has_tinytex) "tinytex"
      else if (nzchar(sys_pdf)) "system"
      else NA_character_
    },
    tinytex = if (has_tinytex) "tinytex" else NA_character_,
    system  = if (nzchar(sys_pdf)) "system" else NA_character_
  )

  if (is.na(engine)) {
    if (latex == "tinytex") {
      stop("latex = 'tinytex' requested but TinyTeX is not installed.\n",
           "  Run: tinytex::install_tinytex()")
    }
    if (latex == "system") {
      stop("latex = 'system' requested but pdflatex not found on PATH.\n",
           "  Install MiKTeX: https://miktex.org/download\n",
           "  or TeX Live:    https://tug.org/texlive/")
    }
    stop("No LaTeX distribution found.\n",
         "  Install MiKTeX: https://miktex.org/download\n",
         "  or run:         tinytex::install_tinytex()")
  }

  if (engine == "system") {
    # Make tinytex::is_tinytex() return FALSE by pointing its root at a
    # path that does not exist.  rmarkdown then falls back to Sys.which()
    # and calls the system pdflatex (MiKTeX / TeX Live) directly.
    Sys.setenv(TINYTEX_INSTALLED_ROOT = file.path(tempdir(), ".no_tinytex_sentinel"))
    alt <- if (has_tinytex) " (TinyTeX also present; use latex = 'tinytex' to switch)" else ""
    message("LaTeX: system — ", sys_pdf, alt)
  } else {
    alt <- if (nzchar(sys_pdf)) paste0(" (system pdflatex also at ", sys_pdf, "; use latex = 'system' to switch)") else ""
    message("LaTeX: TinyTeX", alt)
  }

  invisible(engine)
}

# ------------------------------------------------------------------
# Vitae template patch self-check
# ------------------------------------------------------------------
# The latexcv template at the path below has been manually patched for
# FontAwesome 5 and a bottom-margin fix.  Reinstalling/upgrading the
# `vitae` package overwrites the template silently, which surfaces as
# missing footer icons or clipped text in the rendered PDF.
#
# This check reads the installed template and warns if the expected
# patch markers are absent.  Non-fatal — it just prints to the console.

check_vitae_patch <- function() {
  tmpl <- system.file(
    "rmarkdown/templates/latexcv/resources/classic/main.tex",
    package = "vitae"
  )
  if (!nzchar(tmpl) || !file.exists(tmpl)) {
    message("vitae patch check: template not found at expected path; skipping.")
    return(invisible(FALSE))
  }
  txt <- readLines(tmpl, warn = FALSE)
  blob <- paste(txt, collapse = "\n")

  checks <- list(
    fontawesome5 = grepl("\\\\usepackage\\{fontawesome5\\}", blob),
    bottom_2cm = grepl("bottom=2cm", blob, fixed = TRUE),
    faIcon = grepl("\\\\faIcon\\{", blob)
  )
  missing <- names(checks)[!unlist(checks)]
  if (length(missing) > 0) {
    warning(
      "vitae template patch appears incomplete (missing: ",
      paste(missing, collapse = ", "),
      "). Footer icons / margins may break. ",
      "Re-apply patch from README.md to: ",
      tmpl,
      call. = FALSE
    )
    return(invisible(FALSE))
  }
  invisible(TRUE)
}

# ------------------------------------------------------------------
# Render helper — wraps rmarkdown::render with log-tail-on-error
# ------------------------------------------------------------------

render_one <- function(input, output_dir, output_file, params, quiet) {
  args <- list(
    input = input,
    output_dir = output_dir,
    output_file = output_file,
    quiet = quiet,
    envir = new.env(parent = globalenv())
  )
  if (length(params) > 0) {
    args$params <- params
  }
  tryCatch(
    do.call(rmarkdown::render, args),
    error = function(e) {
      log_path <- file.path(
        output_dir,
        paste0(tools::file_path_sans_ext(output_file), ".log")
      )
      if (!file.exists(log_path)) {
        log_path <- "cv.log"
      }
      if (file.exists(log_path)) {
        message("\n--- Last 30 lines of ", log_path, " ---")
        log_lines <- readLines(log_path, warn = FALSE)
        message(paste(utils::tail(log_lines, 30), collapse = "\n"))
        message("--- end log tail ---\n")
      }
      stop(e)
    }
  )
}

# ------------------------------------------------------------------
# Render function
# ------------------------------------------------------------------

render_cv <- function(
  profile    = "full",
  output_dir = "output",
  quiet      = FALSE,
  dated      = FALSE,
  latex      = c("auto", "tinytex", "system")
) {
  latex <- match.arg(latex)

  if (!file.exists("cv.qmd")) {
    stop(
      "Working directory must be the CV repo root (cv.qmd not found in '",
      getwd(),
      "')."
    )
  }
  setup_latex(latex)
  check_vitae_patch()

  if (identical(profile, "all")) {
    results <- lapply(names(profiles), function(p) {
      t0 <- Sys.time()
      out <- tryCatch(
        render_cv(p, output_dir = output_dir, quiet = quiet, dated = dated, latex = latex),
        error = function(e) {
          message("FAILED ", p, ": ", conditionMessage(e))
          NA_character_
        }
      )
      list(
        profile = p,
        output = out,
        seconds = round(
          as.numeric(difftime(Sys.time(), t0, units = "secs")),
          1
        ),
        ok = !is.na(out)
      )
    })
    message("\n--- Render summary ---")
    for (r in results) {
      status <- if (r$ok) "OK   " else "FAIL "
      message(sprintf(
        "  %s %-20s %5.1fs  %s",
        status,
        r$profile,
        r$seconds,
        if (r$ok) r$output else "(failed)"
      ))
    }
    message("--- end summary ---")
    return(invisible(results))
  }

  if (!profile %in% names(profiles)) {
    stop(
      "Unknown profile '",
      profile,
      "'. Available: ",
      paste(names(profiles), collapse = ", ")
    )
  }

  overrides <- profiles[[profile]]
  suffix <- if (profile == "full") "" else paste0("_", profile)
  date_suffix <- if (isTRUE(dated)) {
    paste0("_", format(Sys.Date(), "%Y-%m-%d"))
  } else {
    ""
  }
  out_file <- paste0("cv", suffix, date_suffix, ".pdf")

  message(
    "Rendering profile: ",
    profile,
    " -> ",
    file.path(output_dir, out_file)
  )

  render_one(
    input = "cv.qmd",
    output_dir = output_dir,
    output_file = out_file,
    params = overrides,
    quiet = quiet
  )

  out_path <- file.path(output_dir, out_file)
  if (!file.exists(out_path)) {
    stop("Render returned but output file missing: ", out_path)
  }
  fsize <- file.info(out_path)$size
  if (fsize < 50000) {
    warning(
      "Output PDF suspiciously small (",
      fsize,
      " bytes): ",
      out_path,
      call. = FALSE
    )
  }
  magic <- tryCatch(
    rawToChar(readBin(out_path, what = "raw", n = 4)),
    error = function(e) ""
  )
  if (!startsWith(magic, "%PDF")) {
    stop(
      "Output file is not a valid PDF (magic bytes: '",
      magic,
      "'): ",
      out_path
    )
  }

  message("Done: ", file.path(output_dir, out_file))
  invisible(file.path(output_dir, out_file))
}

# ------------------------------------------------------------------
# CLI entry point
# ------------------------------------------------------------------

if (!interactive()) {
  args      <- commandArgs(trailingOnly = TRUE)
  flags     <- args[startsWith(args, "--")]
  positional <- args[!startsWith(args, "--")]
  profile   <- if (length(positional) >= 1) positional[1] else "full"

  latex_flag <- grep("^--latex=", flags, value = TRUE)
  latex_val  <- if (length(latex_flag)) sub("^--latex=", "", latex_flag[1]) else "auto"

  render_cv(
    profile,
    quiet = "--quiet" %in% flags,
    dated = "--dated" %in% flags,
    latex = latex_val
  )
}

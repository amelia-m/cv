# render.R — Render CV variants from a single cv.qmd source
#
# Usage:
#   Rscript R/render.R                  # full academic CV (default)
#   Rscript R/render.R faculty          # faculty application (no manuscripts in progress)
#   Rscript R/render.R industry         # non-academic (trimmed)
#   Rscript R/render.R coursework       # full CV + graduate coursework supplement
#   Rscript R/render.R coursework-only  # standalone coursework listing
#
# Or source() interactively and call:
#   render_cv("faculty")  # after source("R/render.R")
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
    show_manuscripts   = FALSE,
    show_preprints     = FALSE,
    show_presentations = FALSE,
    show_training      = FALSE,
    show_mentoring     = FALSE,
    show_lab_skills    = FALSE,
    show_languages     = FALSE,
    show_profiles      = FALSE,
    show_credentials   = FALSE
  ),

  # Full CV with coursework appended
  coursework = list(
    show_coursework   = TRUE,
    coursework_detail = "full"
  ),

  # Coursework summary only (area counts)
  `coursework-summary` = list(
    show_coursework   = TRUE,
    coursework_detail = "summary"
  ),

  # Standalone coursework supplement — everything else off
  `coursework-only` = list(
    show_manuscripts   = FALSE,
    show_preprints     = FALSE,
    show_presentations = FALSE,
    show_training      = FALSE,
    show_mentoring     = FALSE,
    show_lab_skills    = FALSE,
    show_languages     = FALSE,
    show_profiles      = FALSE,
    show_credentials   = FALSE,
    show_coursework    = TRUE,
    coursework_detail  = "both"
  )
)

# ------------------------------------------------------------------
# Render function
# ------------------------------------------------------------------

render_cv <- function(profile = "full", output_dir = "output") {
  if (!profile %in% names(profiles)) {
    stop("Unknown profile '", profile, "'. Available: ",
         paste(names(profiles), collapse = ", "))
  }

  overrides <- profiles[[profile]]
  suffix <- if (profile == "full") "" else paste0("_", profile)
  out_file <- paste0("cv", suffix, ".pdf")

  message("Rendering profile: ", profile, " -> ", file.path(output_dir, out_file))

  # When no overrides, omit params arg entirely so rmarkdown uses YAML defaults.
  # When overrides exist, pass them — rmarkdown merges with YAML defaults.
  if (length(overrides) == 0) {
    rmarkdown::render(
      input       = "cv.qmd",
      output_dir  = output_dir,
      output_file = out_file,
      quiet       = TRUE
    )
  } else {
    rmarkdown::render(
      input       = "cv.qmd",
      output_dir  = output_dir,
      output_file = out_file,
      params      = overrides,
      quiet       = TRUE
    )
  }

  message("Done: ", file.path(output_dir, out_file))
  invisible(file.path(output_dir, out_file))
}

# ------------------------------------------------------------------
# CLI entry point
# ------------------------------------------------------------------

if (!interactive()) {
  args <- commandArgs(trailingOnly = TRUE)
  profile <- if (length(args) >= 1) args[1] else "full"
  render_cv(profile)
}

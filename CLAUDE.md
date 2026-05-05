# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Rendering

Use `rmarkdown::render`, **not** `quarto render` — the `vitae` package uses the R Markdown pipeline and is incompatible with the Quarto CLI.

```r
# From R (interactive or Rscript)
source("R/render.R")                # full academic CV → output/cv.pdf
```

Named profiles (pass as first arg to `Rscript R/render.R <profile>`):

| Profile | Output |
|---------|--------|
| `full` (default) | All sections |
| `faculty` | No manuscripts in progress |
| `industry` | Lean version — drops presentations, training, lab skills, etc. |
| `coursework` | Full CV + graduate coursework appendix |
| `coursework-only` | Standalone coursework supplement |

Or call directly: `render_cv("faculty")` after `source("R/render.R")`.

Requires internet to fetch live Scholar citation metrics; falls back to hardcoded values in the `setup` chunk of `cv.qmd` if Scholar is unreachable. Update those fallback values after any offline render.

## Checking for new publications

```r
source("R/update_bib.R")           # prints report; never modifies .bib files
# To save: source("R/update_bib.R"); writeLines(report, "bib-reviews/bib_review.txt")
```

Fetches Google Scholar + ORCID, cross-references against `bib/publications.bib`, `bib/presentations.bib`, `R/cv_data.R` preprints, and `R/bib_ignore.R` allowlists. Reports: unmatched titles, year discrepancies, missing DOIs, incomplete volume/page data.

Add persistent false positives to `R/bib_ignore.R` — year-discrepancy allowlist or `extra_matched_titles`.

## Architecture

Data flows in one direction: source files → `cv.qmd` → PDF.

```
R/cv_data.R          # All structured data (tribbles): education, positions, awards,
                     #   software, manuscripts, preprints, mentoring, training, etc.
R/coursework_data.R  # Graduate coursework — only sourced when show_coursework=TRUE
bib/publications.bib   # Peer-reviewed articles (BibTeX; authoritative)
bib/presentations.bib  # Conference presentations (BibTeX; authoritative)
       ↓
cv.qmd               # Layout + section order; params control which sections render
       ↓
R/render.R           # Profile system — wraps rmarkdown::render with param overrides
       ↓
output/cv.pdf
```

Section visibility is controlled entirely by `params` in `cv.qmd` YAML — `show_*` booleans. Profiles in `render.R` override these; anything not overridden inherits the YAML default (all `true` except `show_coursework`).

**Source of record for content:** `docs/Miramonti_CV_2026-03-04.md` is the authoritative plain-text CV. Content edits go there first, then propagate to `cv_data.R` / `.bib` files.

**Open items before v1.0.0:** tracked in `docs/Miramonti_CV_review_notes.md`.

## Key quirks

- **vitae LaTeX patch** — the installed `vitae` latexcv template (`classic/main.tex`) has been manually patched for FontAwesome 5 and a negative bottom-margin fix. This patch lives at `C:\Users\ameli\AppData\Local\R\win-library\4.5\vitae\rmarkdown\templates\latexcv\resources\classic\main.tex` and **will be overwritten if `vitae` is reinstalled or updated**. Re-apply if ORCID/Scholar/ResearchGate footer icons disappear. See README for exact line numbers.

- **Running headers suppressed** — `cv.qmd` injects `\fancyhf{}` + `\renewcommand{\headrulewidth}{0pt}` to suppress the default `\rightmark` running header that the latexcv template enables without explicitly clearing.

- **Author bold** — Miramonti's name is bolded in publications via a `mutate` that wraps `\textbf{Miramonti}` around the family name in the author list.

- **`conflicted` package** — both `cv.qmd` and `cv_data.R` load `conflicted` and call `conflicts_prefer(dplyr::filter, dplyr::select)` to prevent ambiguity with other loaded packages.

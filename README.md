# Amelia A. Miramonti — Curriculum Vitae

Reproducible, version-controlled CV built with [Quarto](https://quarto.org) and the [`vitae`](https://pkg.mitchelloharawild.com/vitae/) R package (`awesomecv` template).

## Repository structure

| File | Purpose |
|------|---------|
| `cv.qmd` | Main CV document — layout and section order |
| `cv_data.R` | Structured data (education, positions, awards, skills, etc.) |
| `publications.bib` | BibTeX — 31 peer-reviewed journal articles |
| `presentations.bib` | BibTeX — ~53 conference presentations |
| `render.R` | One-liner render script (see below) |
| `update_bib.R` | Standalone script — fetches Scholar + ORCID, reports new/changed entries |
| `Miramonti_CV_2026-03-04.md` | Authoritative plain-text CV — source of record for content edits |
| `Miramonti_CV_review_notes.md` | Open items and change log |

## Prerequisites

- **R ≥ 4.5** — [https://cran.r-project.org](https://cran.r-project.org)
- **Quarto** — bundled in [Positron](https://positron.posit.co) or install standalone from [https://quarto.org](https://quarto.org)
- **R packages:**

```r
install.packages(c("vitae", "tibble", "dplyr", "purrr", "glue",
                   "conflicted", "RefManageR", "rmarkdown", "knitr",
                   "scholar", "rorcid", "stringr"))
```

- **TinyTeX** (LaTeX for PDF rendering):

```r
tinytex::install_tinytex()   # one-time, ~5 min
```

## Rendering

Open Positron, set the working directory to this repo, then run:

```r
source("render.R")
```

Output: `output/cv.pdf`

> **Note:** Use `rmarkdown::render("cv.qmd")`, not `quarto render cv.qmd`.
> The `vitae` package uses the R Markdown rendering pipeline;
> the Quarto CLI does not support `vitae` output formats directly.

## Checking for new publications (`update_bib.R`)

Run periodically (e.g., before re-submitting a job application) to catch new
publications or updated metadata:

```r
source("update_bib.R")
```

The script fetches your publication list from **Google Scholar** and **ORCID**,
compares both against `publications.bib`, and prints a report covering:

| Section | What it checks |
|---------|---------------|
| 1 | Papers on Scholar not found in bib (likely new publications) |
| 2 | Year discrepancies between bib and Scholar |
| 3 | ORCID works not matched in bib |
| 4 | DOI enrichment — ORCID has a DOI that the bib entry is missing |
| 5 | Bib entries missing volume / pages (and not flagged as online-first) |

**The script never modifies `publications.bib`** — all updates are manual.
To also save the report to a file:

```r
source("update_bib.R"); writeLines(report, "bib_review.txt")
```

> **Requires:** `scholar`, `rorcid`, `stringr` — install once with
> `install.packages(c("scholar", "rorcid", "stringr"))`.

## Known patch: vitae latexcv template (FontAwesome 5)

The installed `vitae` latexcv template (`classic/main.tex`) ships with a mixed
FontAwesome 4/5 setup that causes a LaTeX compile error for the `orcid`, `scholar`,
and `researchgate` footer fields. The following manual patch was applied to the
installed template file:

**File:** `C:\Users\ameli\AppData\Local\R\win-library\4.5\vitae\rmarkdown\templates\latexcv\resources\classic\main.tex`

**Changes:**
- Line 106: `\usepackage{fontawesome}` → `\usepackage{fontawesome5}`
- Lines 395–397: all `\faicon{...}` → `\faIcon{...}` (also updated `map-marker` → `map-marker-alt`)
- Lines 441–446: remaining `\faicon{...}` → `\faIcon{...}`
- Line 86: `bottom=-.6cm` → `bottom=2cm` (negative margin caused text to overflow and get clipped at page bottoms)

> ⚠️ **This patch will be overwritten if `vitae` is reinstalled or updated.**
> Re-apply the changes above if ORCID/Scholar/ResearchGate icons disappear from
> the footer after a package update.
>
> A PR to fix this upstream in the vitae package is planned.

---

## Versioning

- **`main` branch** — always reflects the current complete CV
- **Feature branches** — use `feature/short-version`, `feature/teaching-cv`, etc. for tailored variants
- **Semantic tags** — tag each "published" version (e.g., when submitting a job application):
  ```
  git tag -a v1.0.0 -m "First full render — April 2026"
  git push origin --tags
  ```
- Attach the rendered PDF to the corresponding GitHub Release

## Open items (⚠️ hold v1.0.0)

See `Miramonti_CV_review_notes.md` for full details. Outstanding items:

1. Wick K et al. APA 2024 — confirm presentation occurred; add full author list
2. Bovaird et al. IMPS 2024 Prague — confirm presentation occurred
3. OSF preprint authorship (doi:10.17605/osf.io/m3rpv) and Wick K connection
4. Software section — confirm accuracy and proficiency levels
5. Languages (German ~30%, Italian ~55%) — confirm whether to keep
6. Phone number — add if desired
7. Peiwen's AERA presentation — add details when available
8. Zhenqiao's project — confirm status and listing

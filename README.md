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
| `Miramonti_CV_2026-03-04.md` | Authoritative plain-text CV — source of record for content edits |
| `Miramonti_CV_review_notes.md` | Open items and change log |

## Prerequisites

- **R ≥ 4.5** — [https://cran.r-project.org](https://cran.r-project.org)
- **Quarto** — bundled in [Positron](https://positron.posit.co) or install standalone from [https://quarto.org](https://quarto.org)
- **R packages:**

```r
install.packages(c("vitae", "tibble", "dplyr", "purrr", "glue",
                   "conflicted", "RefManageR", "rmarkdown", "knitr"))
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

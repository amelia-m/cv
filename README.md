# Amelia A. Miramonti — Curriculum Vitae

Reproducible, version-controlled academic CV built with the [`vitae`](https://pkg.mitchelloharawild.com/vitae/) R package (`latexcv` / classic template) and rendered via **R Markdown + knitr** — not the Quarto CLI (see note below).

## Repository structure

| File | Purpose |
|------|---------|
| `cv.qmd` | Main CV document — layout and section order |
| `R/cv_data.R` | Structured data (education, positions, awards, skills, etc.) |
| `R/coursework_data.R` | Graduate coursework data (sourced only when `show_coursework = TRUE`) |
| `R/render.R` | Profile-based render script (see below) |
| `R/update_bib.R` | Standalone script — fetches Scholar + ORCID, reports new/changed entries |
| `R/bib_ignore.R` | Allowlists for `update_bib.R` (known-stale years, non-bib titles) |
| `bib/publications.bib` | BibTeX — peer-reviewed journal articles |
| `bib/presentations.bib` | BibTeX — conference presentations |
| `bib-reviews/bib_review_notes.md` | Rolling log of bib reconciliation decisions |
| `docs/Miramonti_CV_2026-03-04.md` | Authoritative plain-text CV — source of record for content edits |
| `docs/Miramonti_CV_review_notes.md` | Open items and change log |

## Prerequisites

- **R ≥ 4.5** — [https://cran.r-project.org](https://cran.r-project.org)
- **Quarto** — not required for rendering (see note below), but bundled in [Positron](https://positron.posit.co) which is the recommended IDE
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

Open Positron (or any R console), set the working directory to this repo, then run:

```r
source("R/render.R")
```

Output: `output/cv.pdf`

### Render profiles

Multiple named profiles are available to produce targeted variants:

| Profile | Command | Output |
|---------|---------|--------|
| `full` *(default)* | `render_cv()` | All sections — full academic CV |
| `faculty` | `render_cv("faculty")` | Drops manuscripts in progress |
| `industry` | `render_cv("industry")` | Lean version — drops presentations, training, lab skills, etc. |
| `coursework` | `render_cv("coursework")` | Full CV + graduate coursework (full course list) |
| `coursework-summary` | `render_cv("coursework-summary")` | Full CV + graduate coursework (area-count summary only) |
| `coursework-only` | `render_cv("coursework-only")` | Standalone coursework supplement |
| `all` | `render_cv("all")` | Render every profile sequentially, with a summary table |

You can also pass `--dated` or `--quiet` flags via `Rscript`:

```r
Rscript R/render.R faculty          # faculty profile
Rscript R/render.R full --dated     # cv_2026-05-04.pdf (date-stamped)
Rscript R/render.R full --quiet     # suppress LaTeX progress output
```

> **Note:** Use `rmarkdown::render("cv.qmd")`, not `quarto render cv.qmd`.
> The `vitae` package uses the R Markdown rendering pipeline;
> the Quarto CLI does not support `vitae` output formats directly.

> **Pandoc note:** rendering needs pandoc on the PATH. Positron/RStudio set
> this up automatically, so rendering from an IDE console "just works." A bare
> `Rscript` from a plain shell fails with *"pandoc version 1.12.3 or higher is
> required and was not found"* — set `RSTUDIO_PANDOC` to a dir containing
> `pandoc.exe` first (e.g. RStudio's bundle at
> `C:\Program Files\RStudio\resources\app\bin\quarto\bin\tools`, or a Quarto
> install at `C:\Program Files\Quarto\bin\tools`).

## Checking for new publications (`update_bib.R`)

Run periodically (e.g., before re-submitting a job application) to catch new
publications or updated metadata:

```r
source("R/update_bib.R")
```

The script fetches your publication list from **Google Scholar** and **ORCID**,
and compares both against a pooled "known titles" vector built from:

- `bib/publications.bib` (authoritative for Sections 2, 4, 5)
- `bib/presentations.bib` (conference abstracts, posters, invited talks)
- `R/cv_data.R` → `preprints_data` (preprints/working papers)
- `R/bib_ignore.R` → `extra_matched_titles` (dissertations, theses, known parsing artifacts)

It then prints a report covering:

| Section | What it checks |
|---------|---------------|
| 1 | Scholar publications not matched against any known source |
| 2 | Year discrepancies between bib and Scholar (excluding allowlist) |
| 3 | ORCID works not matched against any known source |
| 4 | DOI enrichment — ORCID has a DOI that the bib entry is missing |
| 5 | Bib entries missing volume / pages (and not flagged as online-first) |
| 6 | Manuscript pipeline — staleness of `manuscripts_data` statuses and promotion candidates (see below) |

**The script never modifies `publications.bib`** — all updates are manual.
To also save the report to a file:

```r
source("R/update_bib.R"); writeLines(report, "bib-reviews/bib_review.txt")
```

### Tracking manuscripts under review (Section 6)

Manuscripts that Scholar/ORCID can't see yet (in prep, under review, R&R)
live in `R/cv_data.R::manuscripts_data` with internal tracking columns:

| Column | Purpose |
|--------|---------|
| `status` | Controlled vocabulary (`manuscript_statuses`): In progress, Under review, Revise & Resubmit, Accepted. Rendered on the CV. |
| `journal` | Target journal — internal unless the `show_manuscript_journals` param is `TRUE` |
| `submitted` | `"YYYY-MM-DD"` submitted to the current journal (internal) |
| `status_date` | `"YYYY-MM-DD"` the status was last **verified** (internal) |
| `notes` | Free-text internal notes (never rendered) |

Every `update_bib.R` run audits this table:

- **Staleness** — any row whose `status_date` is `NA` or older than **60 days**
  is flagged `NEEDS STATUS CHECK`. After verifying a status (journal portal,
  email, co-author), update `status_date` even if the status didn't change.
- **Promotion** — manuscript titles are fuzzy-matched against the works
  fetched from Scholar/ORCID. A match means the paper is now public:
  add it to `bib/publications.bib` (with `note = {Published online ...}` if
  volume/pages aren't out yet — Section 5 then tracks completion) and
  **delete the row** from `manuscripts_data`.

Manuscript titles are deliberately *not* added to the known-titles pool, so
a newly published manuscript also appears in Section 1/3 as unmatched —
Section 6 tells you why.

### Suppressing known false positives (`R/bib_ignore.R`)

Some discrepancies are persistent but legitimate — e.g., Google Scholar reports
an Epub-ahead-of-print year while `publications.bib` uses the final print year.
To stop these from surfacing on every rerun, add them to `R/bib_ignore.R`:

```r
# Year-discrepancy allowlist (bib key → reason)
ignore_year_discrepancies <- list(
  lamonica2016critical = "Scholar shows Epub 2015; print is 2016 (PMID 26329841)"
)

# Titles to treat as "already in the CV" without a bib entry
extra_matched_titles <- c(
  "My dissertation title here",
  "A Scholar parsing artifact title"
)
```

The allowlist reasons are echoed at the bottom of Section 2 as a reminder.

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
- Lines 384–385: header restructured to **two lines** — name alone on line 1
  (`\HUGE`), then `docname` + `position` on line 2 (`\small`), with the `sectcol`
  rule as the separator. Replaces the original single-line `name | docname` layout,
  which wrapped awkwardly once `docname` was set to "Curriculum Vitae". New form:
  ```latex
  \HUGE \textsc{$name$$if(surname)$ $surname$$endif$}\\[4pt]
  \small \textsc{$if(docname)$$docname$$else$Resume$endif$}$if(position)$ \textcolor{sectcol}{\rule[-1mm]{0.8mm}{0.32cm}} $position$$endif$
  ```

(Note: the actual install path uses the current Windows user — e.g.
`C:\Users\amiramonti2\AppData\Local\R\win-library\4.5\vitae\...` — not the
`ameli` path shown above.)

> ⚠️ **This patch will be overwritten if `vitae` is reinstalled or updated.**
> Re-apply the changes above if ORCID/Scholar/ResearchGate icons disappear from
> the footer, page text clips at the bottom, or the header reverts to a single
> line / says "Resume" after a package update.
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

See `docs/Miramonti_CV_review_notes.md` for full details. Outstanding items:

1. Wick K et al. APA 2024 — confirm presentation occurred; add full author list
2. Bovaird et al. IMPS 2024 Prague — confirm presentation occurred
3. OSF preprint authorship (doi:10.17605/osf.io/m3rpv) and Wick K connection
4. Software section — confirm accuracy and proficiency levels
5. Languages (German ~30%, Italian ~55%) — confirm whether to keep
6. Phone number — add if desired
7. Peiwen's AERA presentation — add details when available
8. Zhenqiao's project — confirm status and listing

# Submission-email → CV integration (Phase 1) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the two new under-review manuscripts to the CV and document a repeatable email→`manuscripts_data` workflow.

**Architecture:** Append two rows to the `manuscripts_data` tribble in `R/cv_data.R` (each row is the data contract from the spec), then write `docs/submission_email_workflow.md` capturing the Claude-driven extraction/validation procedure (which doubles as the phase-2 R-parser spec). Verification is data-driven, not unit-test-driven: `update_bib.R` Section 6 and a full render are the checks.

**Tech Stack:** R (tibble/tribble, vitae, rmarkdown), `update_bib.R` audit script. Render needs `RSTUDIO_PANDOC` set (pandoc not on PATH from bare Rscript).

Spec: `docs/superpowers/specs/2026-06-08-submission-email-to-cv-design.md`

---

## Reference: render/audit commands (Windows, bare Rscript)

```powershell
$rs = "C:\Program Files\R\R-4.5.2\bin\Rscript.exe"
$env:RSTUDIO_PANDOC = "C:\Program Files\RStudio\resources\app\bin\quarto\bin\tools"
& $rs -e "source('R/update_bib.R')"   # audit (Section 6)
& $rs "R/render.R"                     # render -> output/cv.pdf
```

Both emit progress on stderr → PowerShell reports NativeCommandError / exit 1 even on success. Judge by the printed output, not the exit code.

---

## Task 1: Add the two manuscripts to `manuscripts_data`

**Files:**
- Modify: `R/cv_data.R` (the `manuscripts_data <- tribble(...)` block; currently 7 rows ending with the Fukuda "Improved critical power…" row)

**Column order** (from the tribble header): `authors, title, status, journal, submitted, status_date, notes`. Existing rows place authors / title / status each on its own line, then the remaining four cells (`journal, submitted, status_date, notes`) on one line — all currently `NA_character_`. The new rows are the FIRST with non-NA `journal/submitted/status_date/notes`.

- [ ] **Step 1: Record expected post-change audit state (the "test")**

Before editing, note what `update_bib.R` Section 6 must show AFTER the edit:
- Total manuscripts audited: **9** (was 7).
- The two new titles ("Latino Consumer Food Environments…" and "The Role of Motivated Cognition in Transphobia…") appear in Section 6.
- Neither new row is flagged `NEEDS STATUS CHECK` — both have `status_date = "2026-06-08"` (current, < 60 days).
- The original 7 rows still flagged `NEEDS STATUS CHECK` (still NA status_date) — unchanged.
- 0 promotion candidates from the new rows (titles not yet on Scholar/ORCID).

- [ ] **Step 2: Add a trailing comma to the current last cell**

The current final row ends:
```r
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_
)
```
Change the last `NA_character_` (the one with no trailing comma, before `)`) to have a trailing comma:
```r
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
```

- [ ] **Step 3: Append the two new rows before the closing `)`**

Insert these two rows immediately after the line edited in Step 2 and before `)`:
```r
  "Santos N, Miramonti AA, Fox G, Abresch C, Franzen-Castle L" ,
  "Latino Consumer Food Environments: A cross-sectional analysis of rural food retailers" ,
  "Under review" ,
  "Nutrition & Dietetics" , "2026-05-28" , "2026-06-08" , "Manuscript ID 4212250; ORCID co-author verification" ,
  "Vargas J, Miramonti AA, Abbott D" ,
  "The Role of Motivated Cognition in Transphobia: Need for Closure, Gender Essentialism, and Intergroup Contact" ,
  "Under review" ,
  "Sex Roles" , "2026-06-02" , "2026-06-08" , "Submission ID 3d1fd576-28b8-435c-9741-007d154a60ab; co-author"
)
```
Note: the Sex Roles row (last) has NO trailing comma before `)`. Column-whitespace padding need not be hand-perfect (R ignores it); a later Air run will normalize alignment.

- [ ] **Step 4: Sanity-check the tribble parses**

Run:
```powershell
$rs = "C:\Program Files\R\R-4.5.2\bin\Rscript.exe"
& $rs -e "source('R/cv_data.R'); cat('manuscripts rows:', nrow(manuscripts_data), '\n'); print(manuscripts_data[8:9, c('title','status','journal','submitted','status_date')])"
```
Expected: `manuscripts rows: 9`, and rows 8–9 show the two new titles with status "Under review", correct journals, submitted dates, and status_date 2026-06-08. A comma-misalignment error (shifted cells / parse error) means recount the cells in Step 3.

- [ ] **Step 5: Run the audit to confirm expected state**

Run:
```powershell
$rs = "C:\Program Files\R\R-4.5.2\bin\Rscript.exe"
& $rs -e "source('R/update_bib.R')"
```
Expected (Section 6): 9 manuscripts; the two new ones present and NOT flagged NEEDS STATUS CHECK; original 7 still flagged. (Scholar/ORCID may fail to fetch — env, fine; promotion check skipped.)

- [ ] **Step 6: Commit**

```powershell
git add R/cv_data.R docs/superpowers/specs/2026-06-08-submission-email-to-cv-design.md
git commit -m "feat: add Nutrition & Dietetics and Sex Roles manuscripts under review

Two new under-review co-authored manuscripts added to manuscripts_data
(status_date 2026-06-08). Latino consumer food environments (Nutrition &
Dietetics, submitted 2026-05-28) and Motivated cognition in transphobia
(Sex Roles, submitted 2026-06-02). Includes the finalized submitted date
in the design spec.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```
(The spec file has an uncommitted edit — the Latino `submitted` date — folded into this commit.)

---

## Task 2: Verify the render

**Files:** none modified (verification only)

- [ ] **Step 1: Render the full CV**

Run:
```powershell
$rs = "C:\Program Files\R\R-4.5.2\bin\Rscript.exe"
$env:RSTUDIO_PANDOC = "C:\Program Files\RStudio\resources\app\bin\quarto\bin\tools"
& $rs "R/render.R"
```
Expected: `Output created: output/cv.pdf` / `Done: output/cv.pdf`. Citeproc "citation not found" warnings are benign vitae noise.

- [ ] **Step 2: Confirm both titles appear in the PDF**

Run:
```powershell
$rs = "C:\Program Files\R\R-4.5.2\bin\Rscript.exe"
& $rs -e "txt <- paste(pdftools::pdf_text('output/cv.pdf'), collapse=' '); cat('Latino:', grepl('Latino Consumer Food Environments', txt), '\n'); cat('Transphobia:', grepl('Motivated Cognition in Transphobia', txt), '\n')"
```
Expected: both `TRUE`. (If FALSE, check the `show_manuscripts` param is TRUE for the default `full` profile — it is by default.)

---

## Task 3: Write the email→CV workflow doc

**Files:**
- Create: `docs/submission_email_workflow.md`

- [ ] **Step 1: Write the doc**

Create `docs/submission_email_workflow.md` with this content:
```markdown
# Submission-email → CV workflow

How to turn a journal submission-confirmation email into a
`manuscripts_data` row in `R/cv_data.R`. Phase 1 is Claude-driven;
this doc is also the spec for the future phase-2 R parser
(`docs/superpowers/specs/2026-06-08-submission-email-to-cv-design.md`).

## Steps (Claude-driven)

1. Paste the full confirmation email text to Claude.
2. Claude extracts the fields below, infers `status`, and flags gaps.
3. Claude prompts for any missing **author list** (it renders on the CV).
4. Claude shows the proposed row; you approve or correct.
5. Claude appends the row to `manuscripts_data` and runs `update_bib.R`
   to confirm the row is present and not flagged.

## Field mapping (the data contract)

| Column        | Where it comes from                          | If missing                              |
|---------------|----------------------------------------------|-----------------------------------------|
| `authors`     | usually NOT in the email                      | prompt the user (renders on CV)         |
| `title`       | "Submission Title" / quoted manuscript title  | —                                       |
| `status`      | infer (see below)                             | default `Under review`                  |
| `journal`     | "Journal:" / "submitted to <Journal>"         | prompt the user                         |
| `submitted`   | submission/confirmation date, as `YYYY-MM-DD` | NA (Section 6 flags later)              |
| `status_date` | date you process the email (today)            | always set                              |
| `notes`       | Manuscript ID / Submission ID, co-author role | —                                       |

Author format: `Family Initials, …` in real author order
(corresponding/first author leads). Own name always `Miramonti AA`.

## Status inference

Map to the `manuscript_statuses` vocabulary in `cv_data.R`:
- Submission/receipt confirmation → `Under review`
- Revise-and-resubmit / major-minor revision request → `Revise & Resubmit`
- Acceptance → `Accepted` (then consider promoting to publications.bib)
- Not yet submitted (drafting) → `In progress`

## Validation

- `status` must be one of `manuscript_statuses`.
- Dedup `title` against existing `manuscripts_data` rows and the
  `update_bib.R` known-titles pool (don't double-list, don't re-add a
  published paper).
- Set `status_date` so `update_bib.R` Section 6 doesn't immediately flag
  the new row as stale.
- Dates in `YYYY-MM-DD`.

## After adding

- `source("R/update_bib.R")` — new row present in Section 6, not flagged.
- `source("R/render.R")` — title appears under Manuscripts in Progress.
- When the work later appears on Scholar/ORCID, Section 6 flags it
  PROMOTION CANDIDATE → move to `bib/publications.bib`, delete the row.
```

- [ ] **Step 2: Commit**

```powershell
git add docs/submission_email_workflow.md
git commit -m "docs: add submission-email to CV workflow

Documents the Claude-driven email->manuscripts_data procedure (field
mapping, status inference, validation), doubling as the phase-2 R-parser
spec.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

## Self-review notes

- **Spec coverage:** Data contract → Task 1 rows + Task 3 mapping table. Phase-1 workflow → Task 3 doc. Two manuscripts → Task 1. Verification (audit + render) → Task 1 Step 5, Task 2. Phase 2 is designed-for only (no task — correct, out of build scope).
- **Placeholder scan:** none — all row values and doc content are literal.
- **Type consistency:** column order `authors, title, status, journal, submitted, status_date, notes` consistent across Task 1 and the Task 3 mapping table; `status` values drawn from `manuscript_statuses`.
```

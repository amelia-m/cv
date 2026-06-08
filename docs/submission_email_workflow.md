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

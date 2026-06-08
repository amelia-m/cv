# Design — Submission-email → CV integration

Date: 2026-06-08
Status: approved (design); phase 1 to implement

## Problem

Journal submission-confirmation emails (ORCID co-author verification,
editorial-assistant notices, etc.) carry the facts needed to list a
manuscript as under review on the CV, but arrive in wildly different
formats and never contain the full author list. Need a repeatable way to
turn such an email into a `manuscripts_data` row.

## Goals

- Turn a confirmation email into a validated `manuscripts_data` row.
- Phase 1 (now): Claude-driven extraction + a documented manual workflow.
- Phase 2 (medium–long term, designed-for not built): R-native parser
  with optional **local** LLM fallback — private, offline, all-in-one.
- Both phases feed the SAME data contract and validation, so phase 2
  drops in without rework.

Non-goals: automatic email *ingestion* (IMAP, watching a mailbox);
promoting manuscripts to `publications.bib` (already handled by
`update_bib.R` Section 6).

## Data contract (stable interface — both phases target this)

Sink = `manuscripts_data` tribble in `R/cv_data.R`. One email → one row:

| Column        | From email                         | Gap rule (hybrid)                         |
|---------------|------------------------------------|-------------------------------------------|
| `authors`     | rarely present                     | **prompt immediately** (renders on CV)    |
| `title`       | always present                     | —                                         |
| `status`      | infer → `manuscript_statuses`      | submission confirmation ⇒ `Under review`  |
| `journal`     | present                            | —                                         |
| `submitted`   | sometimes (a date)                 | NA → `update_bib.R` Section 6 flags later |
| `status_date` | = receipt date (entry date)        | always set on entry                       |
| `notes`       | Manuscript/Submission ID, co-author role | —                                   |

Author format: `Family Initials, …` preserving real author order
(corresponding/first author leads). Match existing rows
(e.g. `Miramonti AA, Jeffries J, Riley JH, Bovaird JA`). Miramonti's own
name is always `Miramonti AA`.

Validation at entry:
- `status` ∈ `manuscript_statuses` (`In progress`, `Under review`,
  `Revise & Resubmit`, `Accepted`).
- Dedup `title` against `manuscripts_data` AND the `update_bib.R`
  known-titles pool (catch already-listed or already-published work).
- `status_date` set (so Section 6 doesn't immediately flag the new row).
- Dates `YYYY-MM-DD`.

## Phase 1 — Claude-driven (implement now)

Flow:
1. Paste email text to Claude.
2. Claude extracts fields per the contract, infers `status`, flags gaps.
3. Missing `authors` → Claude prompts user (hybrid rule). Missing
   internal fields (e.g. `submitted`) → `NA_character_`; Section 6 flags.
4. Claude shows the proposed row for approval.
5. On OK: edit `manuscripts_data` in `R/cv_data.R`; run `update_bib.R`
   to confirm clean (new row should NOT be flagged — `status_date` set).

Deliverable: `docs/submission_email_workflow.md` — extraction checklist,
field-mapping table, status-inference rules, validation rules. Doubles
as the phase-2 requirements spec.

## Phase 2 — R-native + optional local LLM (designed-for, not built)

- `parse_submission_email(text)` → row matching the contract.
- Deterministic regex for labeled fields (`Title:`, `Journal:`,
  `Manuscript ID`, submission dates).
- Optional local LLM (e.g. Ollama) fallback for unstructured emails
  (Sex Roles–style prose) — keeps data on-device, no cloud.
- Feeds the SAME validate-and-append helper. Phase 1's workflow doc is
  its spec.
- YAGNI now: no code written. Only the contract is frozen so it drops in.

## Initial data to add (phase 1, now)

Both: `status = "Under review"`, `status_date = "2026-06-08"`.

1. **Latino Consumer Food Environments: A cross-sectional analysis of rural food retailers**
   - authors: `Santos N, Miramonti AA, Fox G, Abresch C, Franzen-Castle L`
   - journal: `Nutrition & Dietetics`
   - submitted: `NA_character_` (not stated in email)
   - notes: `Manuscript ID 4212250; ORCID co-author verification`

2. **The Role of Motivated Cognition in Transphobia: Need for Closure, Gender Essentialism, and Intergroup Contact**
   - authors: `Vargas J, Miramonti AA, Abbott D`
   - journal: `Sex Roles`
   - submitted: `2026-06-02`
   - notes: `Submission ID 3d1fd576-28b8-435c-9741-007d154a60ab; co-author`

## Testing / verification

- After adding rows: `source("R/update_bib.R")` — both new rows present
  in Section 6, NOT flagged NEEDS STATUS CHECK (status_date current).
- Re-render (`source("R/render.R")`) — both titles appear in the
  Manuscripts in Progress section; render succeeds.

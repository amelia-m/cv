# Session notes — 2026-06-05 (Cowork/Claude session)

Repo review + manuscript-pipeline tracking implementation. Context for the
next session (Claude Code or otherwise). See also
`docs/claude_project_notes.md` (durable project notes) and `CLAUDE.md`.

## What was done this session

1. **Repo review** → wrote `docs/claude_project_notes.md` (architecture
   mental model, "things that bite", conventions, repo state).
2. **Manuscript pipeline tracking** (decisions: journal display is
   param-controlled; staleness threshold 60 days):
   - `R/cv_data.R` — `manuscripts_data` extended with `journal`,
     `submitted`, `status_date`, `notes` (all internal); added
     `manuscript_statuses` controlled vocabulary. Existing 7 rows have NA
     in new fields → all will flag NEEDS STATUS CHECK on first audit
     (intentional).
   - `cv.qmd` — new `show_manuscript_journals` param (default false; no
     profile enables it). Manuscripts chunk builds `status_label`
     ("Status — Journal" when param TRUE and submitted/R&R).
   - `R/update_bib.R` — (a) 0-row Scholar fetch now treated as FAILED
     (was silently reporting a false clean pass, observed in the
     2026-06-05 bib review); (b) new SECTION 6 "Manuscript pipeline":
     staleness check (>60 days or NA status_date) + promotion detection
     (manuscript title fuzzy-matches fetched Scholar/ORCID work →
     PROMOTION CANDIDATE). Counts added to STATUS line and exit code.
   - README + CLAUDE.md updated with the Section 6 workflow.

## To-dos (next session)

- [x] **Verify the new code runs** — DONE 2026-06-08 (Claude Code, R 4.5.2).
      `update_bib.R` Section 6 ran clean: all 7 manuscripts flagged NEEDS
      STATUS CHECK / never verified (as designed); report saved. Scholar
      fetch blocked (CAPTCHA → 0-row failed-fetch path worked) and ORCID
      fetch failed (no `ORCID_TOKEN` in non-interactive env) — both env,
      not code; promotion check skipped accordingly. `render.R` full
      profile → `output/cv.pdf` (12 pp, publications + Manuscripts section
      populated). Citeproc "citation not found" warnings are benign vitae
      noise. NOTE: bare `Rscript` needed `RSTUDIO_PANDOC` set (pandoc not
      on PATH) — now documented in CLAUDE.md + README.
- [ ] **Add Amelia's new under-review manuscripts** to `manuscripts_data`
      — she has several to add (authors, title, status, journal,
      submitted, status_date). Not yet provided as of session end.
- [ ] **Backfill `status_date`** on the 7 existing rows as Amelia
      verifies each status.
- [ ] **Commit triage** — large uncommitted diff across nearly all
      tracked files (predates this session) plus this session's changes.
      Delete stray `cv.html` (Quarto artifact) and add `cv.html` to
      `.gitignore`.

## Robustness suggestions discussed but NOT yet implemented

- Cache Scholar citation metrics to a file on successful fetch (replace
  hand-maintained fallback values in cv.qmd setup chunk).
- Centralize Scholar ID / ORCID (currently duplicated in cv.qmd ×2 and
  update_bib.R) into one config.
- `validate_cv_data()` at render time (column/NA/date checks on tribbles)
  to catch tribble comma-misalignment early.
- Rename `docs/Miramonti_CV_2026-03-04.md` → undated name (it's the
  living source of record; the dated filename misleads).
- 0-row/degenerate-result guard for the `get_profile()` metrics fetch in
  cv.qmd (the update_bib.R side is fixed; this side is not).
- `render.R`: warn on unknown `--flags`; empty-tibble guards for
  manuscripts/preprints chunks (vitae errors uninformatively on 0 rows —
  matters once manuscripts start promoting out).

## Promotion workflow (reference)

When Section 6 flags a PROMOTION CANDIDATE: add entry to
`bib/publications.bib` (use `note = {Published online ...}` if no
vol/pages yet — Section 5 tracks completion from there), delete the
`manuscripts_data` row, rerun `update_bib.R` to confirm clean.

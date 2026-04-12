# Bib Review Notes

Rolling log of decisions made while reconciling `publications.bib` with
Google Scholar and ORCID.  Update this file whenever `update_bib.R` surfaces
new issues or when sources disagree.

---

## 2026-04-11 — Initial reconciliation pass

Bib file started with 31 peer-reviewed entries.  Ran `update_bib.R`; resolved
every section below.

### Section 1 — Unmatched Google Scholar entries (27)

These are publications Scholar lists but the bib did not.  After investigation,
**none require a new bib entry** — every real item is already captured in
`publications.bib`, `presentations.bib`, or `cv_data.R` (preprints/dissertation).

**Scholar parsing artifacts (not real papers; ignore)**
- `[1]` "Back Issues" (Gonzalez et al., *JSSM* 2011) — journal navigation heading, not a paper.
- `[6]` "Open Library of Bioscience" (Gold et al., NA) — aggregated citation record.
- `[27]` "Institute of Exercise Physiology and Wellness, University of Central Florida, Orlando, USA" — affiliation string scraped as a title.

**Already in `presentations.bib`** (verified by the improved `update_bib.R`
after it was extended to cross-reference `presentations.bib` — see update below)
- `[3]` Pharmacokinetics of caffeine (JISSN 2014) → `gonzalez2014caffeine_abs`
- `[4]` Test-retest reliability of 40-yd dash / vertical jump (ACSM 2017)
- `[5]` Effects of speed and agility training on combine performance (ACSM 2017)
- `[8]` Unidimensionality and internal consistency reliability of step counts (ACSM 2019)
- `[9]` WeCook healthy eating behavior frequency (CDN 2019)
- `[11]` Eight lessons of CATCH® curricula for Hispanic/Latino students (JAND 2017)
- `[12]` Leukemia inhibitory factor response to resistance training (ACSM 2017)
- `[13]` Power push-up tests from knees and toes (ACSM 2017)
- `[14]` Physiological responses underlying perception of effort (ACSM 2016)
- `[16]` Work-to-rest ratios on peak torque and neuromuscular responses (ACSM 2016)
- `[17]` Varied intensity on torque and neuromuscular parameters (ACSM 2016)
- `[18]` Cognitive function and handgrip in older adults (ACSM 2016)
- `[19]` Voluntary activation: ITT vs MMG amplitude (ACSM 2016)
- `[21]` Collegiate track divisions / distance-time relationship (ACSM 2015)
- `[23]` Critical power and heart rate deflection point (ACSM 2015)
- `[25]` Muscle morphology and neuromuscular economy (ACSM 2014)
- `[26]` Anaerobic working capacity and critical power (ACSM 2014)

**Added to `presentations.bib` on 2026-04-11** (these four were flagged as
still unmatched after the script was upgraded to cross-reference presentations.
The original notes on this page erroneously listed them as already present.)
- `[15]` PWCFT estimation in response to HIIT (ACSM 2016 Boston) → `riffe2016pwcft`
- `[20]` Work-to-rest ratios and repeated sprint ability (ACSM 2015 San Diego) → `lamonica2015workrest`
- `[22]` High-intensity resistance training and upper-body muscle/bone (ACSM 2015 San Diego) → `church2015upperbody`
- `[24]` HMB + HIIT and muscle recruitment efficiency (ACSM 2015 San Diego) → `robinson2015hmbhiit`

> **TODO before v1.0.0:** the 4 newly-added entries carry partial author lists
> sourced from Google Scholar (which truncates at ~6 names).  Confirm the full
> author lists against the MSSE 2015 / 2016 abstract books and remove the
> `Partial author list` note from each `note` field.

**Already in `cv_data.R` / other sections**
- `[2]` Reliability of the Woodway Curve non-motorized treadmill (JSSM 2013) —
  A. Miramonti was an undergraduate research assistant; not a listed author.
  **Action:** confirmed not a real authorship.  No bib entry needed.
- `[7]` Youth Sport Participation and Cognitive Development (UNL 2025) →
  dissertation; listed in `cv_data.R` under Education.
- `[10]` Evaluation of the Feasibility of a Two-Method Measurement Design (2018)
  → Master's thesis; listed in `cv_data.R` under Education.

**Design improvement flagged for `update_bib.R`:** ✅ **Completed 2026-04-11.**
Script now cross-references `presentations.bib`, `cv_data.R::preprints_data`,
and a manual allowlist (`bib_ignore.R::extra_matched_titles`) before flagging
Scholar/ORCID entries as unmatched.  Rerunning after the upgrade dropped
Section 1 from 27 → 4, and the 4 remaining items exposed a real gap in
`presentations.bib` that was then filled (see "Added to `presentations.bib`"
block above).

### Section 2 — Year discrepancies (bib vs Scholar)

| Key | Old year | New year | Resolution |
|-----|----------|----------|------------|
| `kim2024workfamily` | 2024 | **2026** | Online-first Dec 8, 2024; print Vol 34(1):3–21 in Feb 2026. Updated year, added vol/iss/pp/DOI. |
| `jenkins2019mechanomyographic` | 2019 | **2021** | Online-first Aug 27, 2019; print Vol 35(11):3265–3269 in Nov 2021. Updated year, added vol/iss/pp/DOI. |
| `mckay2017rhabdomyolysis` | 2017 | 2017 (no change) | Scholar's "2016" reflects an earlier indexing; CrossRef confirms Vol 31(5):1403–1410, May 2017 print. Also corrected title: "healthy female" → "healthy woman". |
| `riffe2016dmax` → `riffe2017dmax` | 2016 | **2017** | Online-first Dec 23, 2016; print Vol 55(3):344–349 in March 2017. Renamed key, added pages + DOI. |
| `lamonica2016critical` | 2016 | 2016 (no change) | Scholar's "2015" reflects Epub-ahead-of-print (Sept 1, 2015); print Vol 56(10):1093–1102 in Oct 2016 (PMID 26329841). |

### Section 3 — ORCID works not matched in bib (3)

All three are already in the project, just not in `publications.bib`:

| Work | Location |
|------|----------|
| Persistence of faculty mentorship (OSF 2024) | `cv_data.R` → `preprints_data` |
| 28-days slow-release caffeine safety (JISSN 2014) | `presentations.bib` → `wells2014caffeine_abs` |
| Pharmacokinetics of caffeine time-release (JISSN 2014) | `presentations.bib` → `gonzalez2014caffeine_abs` |

No bib edits needed.  (Same design-improvement note as Section 1 applies.)

### Section 4 — DOI enrichment (23 entries)

Added DOIs from ORCID to every listed bib entry.  Two items required special
attention:

- **McKay 2020 (two JSCR papers with near-identical titles).**  ORCID returned
  two DOIs and the auto-matcher couldn't tell them apart. Verified via CrossRef:
  - `10.1519/jsc.0000000000002930` → `mckay2020proagility` (Vol 34(4), Apr 2020)
  - `10.1519/jsc.0000000000002532` → `mckay2020normative` (Vol 34(10), Oct 2020)
- **Mangine 2016 (EJAP).**  Bib title said "explosive strength and power";
  DOI `10.1007/s00421-016-3488-6` is the same paper but its official title is
  "rate of force development."  Corrected bib title to match the published
  version.

### Section 5 — Bib entries missing vol/issue/pages (1)

- `riffe2016dmax` → added pages **344–349** and renamed key to `riffe2017dmax`
  (see Section 2).

---

## Open items carried forward

- [x] ~~Sweep `presentations.bib` for the 20 ACSM/JAND/CDN conference abstracts
      listed in Section 1 — confirm all are present with matching metadata.~~
      Completed via the `update_bib.R` upgrade; 17 were already present, 4
      were missing and have been added.
- [x] ~~Extend `update_bib.R` to also cross-reference `presentations.bib` and
      `cv_data.R` (dissertation/preprints) so unmatched-Scholar reports are
      more actionable.~~  Completed 2026-04-11 (commit a94bcd3).
- [x] ~~Rerun `update_bib.R` post-changes to confirm zero outstanding issues
      in Sections 2–5.~~  Confirmed — Sections 2/3/4/5 all clean after the
      reconciliation pass.
- [ ] Confirm full author lists for the 4 newly-added ACSM abstracts
      (`riffe2016pwcft`, `lamonica2015workrest`, `church2015upperbody`,
      `robinson2015hmbhiit`) against the MSSE abstract books, then remove
      the `Partial author list` caveat from each entry's `note` field.
- [ ] Consider adding DOIs for presentation entries where MSSE-supplement
      DOIs are available (low-priority enrichment).

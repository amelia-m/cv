# bib_ignore.R
# Allowlists consumed by update_bib.R.  Items here are treated as "already
# resolved" and will NOT appear in the review report on future runs.
#
# Edit this file whenever you decide a flagged discrepancy is actually fine.
# Each entry should carry a short reason string documenting WHY it's ignored.
# (The reasons are printed back out at the end of Section 2 as a reminder.)
#
# This file is sourced — not parsed — so R syntax applies.

# ── Year discrepancies to suppress ────────────────────────────────────────────
#
# Cases where Google Scholar's year is provably stale (it often reports the
# Epub-ahead-of-print year while publications.bib uses the print year).
# Keys must match entries in publications.bib exactly.

ignore_year_discrepancies <- list(
  lamonica2016critical = "Scholar shows Epub-ahead-of-print 2015; print is 2016 (PMID 26329841)"
)

# ── Extra titles considered "already in the CV" ───────────────────────────────
#
# Used to suppress Scholar/ORCID entries that aren't in publications.bib but
# ARE captured elsewhere — dissertations, theses, posters stored outside bib
# files, Scholar parsing artifacts, etc.
#
# Matching is fuzzy (~70% word overlap), so approximate titles are OK.
# Add a short inline comment above each entry explaining where it lives.

extra_matched_titles <- c(
  # Dissertation — in cv_data.R education_data (PhD, UNL 2025)
  "Youth Sport Participation and Cognitive Development: The Need for Improved Measurement",

  # Master's thesis — in cv_data.R education_data (MA, UNL 2018)
  "Evaluation of the Feasibility of a Two-Method Measurement Design for the Assessment of Healthy Physical Activity Behavior in Youth",

  # Scholar parsing artifacts (not real papers — suppress)
  "Back Issues",
  "Open Library of Bioscience",
  "Institute of Exercise Physiology and Wellness, University of Central Florida, Orlando, USA",

  # Undergraduate lab contribution — not a listed authorship on the paper
  "Reliability of the Woodway Curve non-motorized treadmill for assessing anaerobic performance"
)

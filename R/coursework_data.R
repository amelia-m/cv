# ==============================================================
# Graduate Coursework — UCF (MS) and UNL (MA, PhD)
# ==============================================================
#
# Each row is tagged with:
#   type — "course" (substantive), "thesis", "research", "seminar",
#          "practicum", or "other"
#   area — thematic tag for grouping / summarising
#
# Display code should typically filter to type == "course" (and
# optionally "practicum").  Thesis/dissertation/colloquium hours
# are retained for total-credit-hour accounting.
#
# Transcript quirks (review):
#   - Last row shows Spr 2024 / EDPS 999 titled "Doctoral
#     Dissertation - Fall 2024" — likely a catalog-title artifact
#     or a Spring 2025 enrolment.  Kept verbatim; flag for user.
#   - COMB 104/114 (Krav Maga I & II) included as type "other"
#     so total hours are correct but they won't display in the
#     coursework section.
# ==============================================================

library(tibble)

coursework_data <- tribble(
  ~institution, ~code,          ~title,                                                    ~hours, ~semester,       ~type,        ~area,

  # ── UCF (MS in Sport & Exercise Science / Exercise Physiology) ──

  "UCF", "APK 7139",  "Exercise Biochemistry Techniques",                                  3L, "Summer 2013",  "course",     "Sport Nutrition & Biochemistry",
  "UCF", "PET 7387",  "Exercise Endocrinology",                                            3L, "Summer 2014",  "course",     "Exercise Science & Physiology",
  "UCF", "EDF 6401",  "Statistics for Educational Data",                                   3L, "Spring 2015",  "course",     "Quantitative Methods & Statistics",
  "UCF", "EDF 6481",  "Fundamentals of Graduate Research in Education",                    3L, "Spring 2015",  "course",     "Research Methods & Design",
  "UCF", "PET 6363",  "Dietary & Nutritional Supplements for Athletic Performance",        3L, "Spring 2015",  "course",     "Sport Nutrition & Biochemistry",
  "UCF", "PET 6366",  "Exercise, Nutrition, & Weight Control",                             3L, "Spring 2015",  "course",     "Sport Nutrition & Biochemistry",
  "UCF", "PET 6376",  "Sport Nutrition",                                                   3L, "Spring 2015",  "course",     "Sport Nutrition & Biochemistry",
  "UCF", "PET 6381",  "Physiology of Neuromuscular Mechanisms",                            3L, "Spring 2015",  "course",     "Exercise Science & Physiology",
  "UCF", "PET 6389",  "Physiological Aspects of Sport & Training",                         3L, "Spring 2015",  "course",     "Exercise Science & Physiology",
  "UCF", "PET 6395",  "Program Design in Strength & Conditioning",                         3L, "Spring 2015",  "course",     "Strength & Conditioning",
  "UCF", "PET 6515",  "Assessment & Evaluation in Sport & Exercise Science",               3L, "Spring 2015",  "course",     "Research Methods & Design",
  "UCF", "PET 6357C", "Environmental Perturbations & Human Performance",                   3L, "Spring 2015",  "course",     "Exercise Science & Physiology",
  "UCF", "PET 6971",  "Thesis Hours",                                                     6L, "Spring 2015",  "thesis",     NA_character_,

  # ── UNL — first year (Nutrition & Health Sciences PhD) ──

  "UNL", "NUTR 884",  "Physiology of Exercise",                                           3L, "Fall 2015",    "course",     "Exercise Science & Physiology",
  "UNL", "NUTR 886",  "Exercise Testing & Prescription",                                  4L, "Fall 2015",    "course",     "Exercise Science & Physiology",
  "UNL", "NUTR 999",  "Doctoral Dissertation",                                            3L, "Fall 2015",    "thesis",     NA_character_,
  "UNL", "EDPS 860",  "Applications of Selected Advanced Statistical Methods",             3L, "Spring 2016",  "course",     "Quantitative Methods & Statistics",
  "UNL", "NUTR 999",  "Doctoral Dissertation",                                            6L, "Spring 2016",  "thesis",     NA_character_,
  "UNL", "NUTR 999",  "Doctoral Dissertation",                                            6L, "Summer 2016",  "thesis",     NA_character_,
  "UNL", "EDPS 942",  "Intermediate Statistics: Correlational Methods",                    3L, "Fall 2016",    "course",     "Quantitative Methods & Statistics",
  "UNL", "NUTR 858",  "Nutrition & Exercise",                                             3L, "Fall 2016",    "course",     "Sport Nutrition & Biochemistry",
  "UNL", "NUTR 999",  "Doctoral Dissertation",                                            3L, "Fall 2016",    "thesis",     NA_character_,
  "UNL", "BIOC 831",  "Structure & Metabolism",                                           3L, "Spring 2017",  "course",     "Sport Nutrition & Biochemistry",
  "UNL", "NUTR 896",  "Strength & Conditioning",                                          3L, "Spring 2017",  "course",     "Strength & Conditioning",
  "UNL", "NUTR 999",  "Doctoral Dissertation",                                            3L, "Spring 2017",  "thesis",     NA_character_,
  "UNL", "NUTR 995",  "Doctoral Colloquium",                                              6L, "Summer 2017",  "seminar",    NA_character_,

  # ── UNL — transition to EDPS (Educational Psychology / QRM) ──

  "UNL", "EDPS 991L", "Seminar: Introduction to Longitudinal Methods",                    3L, "Fall 2017",    "course",     "Quantitative Methods & Statistics",
  "UNL", "EDPS 991M", "Seminar: Multilevel Modeling",                                     3L, "Fall 2017",    "course",     "Quantitative Methods & Statistics",
  "UNL", "NRES 898",  "Applied Multivariate Statistics Using R",                           3L, "Fall 2017",    "course",     "Computing & Data Science",
  "UNL", "EDPS 941",  "Intermediate Statistics: Experimental Methods",                     3L, "Spring 2018",  "course",     "Quantitative Methods & Statistics",
  "UNL", "EDPS 970",  "Theory & Methods of Educational Measurement & Evaluation",         3L, "Spring 2018",  "course",     "Psychometrics & Measurement",
  "UNL", "EDPS 971",  "Structural Equation Modeling",                                     3L, "Spring 2018",  "course",     "Psychometrics & Measurement",
  "UNL", "EDPS 845",  "Computer Assisted Research Data Analysis",                         3L, "Summer 2018",  "course",     "Computing & Data Science",
  "UNL", "EDPS 899",  "Masters Thesis",                                                   6L, "Summer 2018",  "thesis",     NA_character_,
  "UNL", "EDPS 899",  "Masters Thesis",                                                   3L, "Fall 2018",    "thesis",     NA_character_,
  "UNL", "EDPS 900A", "Correlational & Experimental Methods in Educational Research",     3L, "Fall 2018",    "course",     "Research Methods & Design",
  "UNL", "EDPS 972",  "Multivariate Analysis",                                            3L, "Fall 2018",    "course",     "Quantitative Methods & Statistics",
  "UNL", "EDPS 854",  "Human Cognition & Instruction",                                    3L, "Spring 2019",  "course",     "Cognitive Science & Development",
  "UNL", "EDPS 900K", "Qualitative Approaches to Educational Research",                   3L, "Spring 2019",  "course",     "Research Methods & Design",
  "UNL", "EDPS 995",  "Doctoral Seminar",                                                 3L, "Spring 2019",  "seminar",    NA_character_,
  "UNL", "EDPS 996A", "Research Other than Thesis",                                       6L, "Summer 2019",  "research",   NA_character_,
  "UNL", "EDPS 922",  "Mind, Brain, and Education",                                       3L, "Fall 2019",    "course",     "Cognitive Science & Development",
  "UNL", "EDPS 996A", "Research Other than Thesis",                                       5L, "Fall 2019",    "research",   NA_character_,
  "UNL", "EDPS 898",  "Special Topics: Grant Writing",                                    3L, "Spring 2020",  "course",     "Professional Development",
  "UNL", "EDPS 980",  "Item Response Theory",                                             3L, "Spring 2020",  "course",     "Psychometrics & Measurement",
  "UNL", "EDPS 996A", "Research Other than Thesis",                                       2L, "Spring 2020",  "research",   NA_character_,
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            9L, "Fall 2020",    "thesis",     NA_character_,
  "UNL", "EDPS 991",  "Seminar: Advanced Modeling and Simulation",                        3L, "Spring 2021",  "course",     "Quantitative Methods & Statistics",
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            6L, "Spring 2021",  "thesis",     NA_character_,
  "UNL", "EDPS 961",  "Cognitive Development",                                            3L, "Fall 2021",    "course",     "Cognitive Science & Development",
  "UNL", "STAT 850",  "Computing Tools for Statistics",                                   2L, "Fall 2021",    "course",     "Computing & Data Science",
  "UNL", "EDPS 996A", "Research Other than Thesis",                                       3L, "Fall 2021",    "research",   NA_character_,
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            1L, "Fall 2021",    "thesis",     NA_character_,
  "UNL", "EDPS 991F", "Advanced Modeling: Fidelity",                                      3L, "Spring 2022",  "course",     "Quantitative Methods & Statistics",
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            6L, "Spring 2022",  "thesis",     NA_character_,
  "UNL", "EDPS 991S", "Testing Special Populations",                                      3L, "Fall 2022",    "course",     "Psychometrics & Measurement",
  "UNL", "EDPS 995",  "Doctoral Seminar",                                                 6L, "Fall 2022",    "seminar",    NA_character_,
  "UNL", "PSYC 971",  "Data Visualization in R",                                          3L, "Spring 2023",  "course",     "Computing & Data Science",
  "UNL", "EDPS 991",  "Advanced Modeling: Miscellaneous",                                  3L, "Spring 2023",  "course",     "Quantitative Methods & Statistics",
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            3L, "Spring 2023",  "thesis",     NA_character_,
  "UNL", "EDPS 896",  "Directed Field Experience",                                        6L, "Summer 2023",  "practicum",  "Professional Development",
  "UNL", "EDPS 900D", "Survey Methods in Educational Research",                           3L, "Fall 2023",    "course",     "Research Methods & Design",
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            6L, "Fall 2023",    "thesis",     NA_character_,
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            1L, "Spring 2024",  "thesis",     NA_character_,
  "UNL", "EDPS 896",  "Directed Field Experience",                                        6L, "Summer 2024",  "practicum",  "Professional Development",
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            1L, "Fall 2024",    "thesis",     NA_character_,
  "UNL", "EDPS 999",  "Doctoral Dissertation",                                            1L, "Spring 2025",  "thesis",     NA_character_,
    # NOTE: transcript shows "Spr 2024 / Doctoral Dissertation - Fall 2024"
    #       — likely Spring 2025 enrolment with catalog title artifact; updated here

  # ── Non-degree / other ──

  "UNL", "COMB 104",  "Krav Maga I",                                                      1L, "Fall 2019",    "other",      NA_character_,
  "UNL", "COMB 114",  "Krav Maga II",                                                     1L, "Spring 2020",  "other",      NA_character_
)


# ==============================================================
# Area definitions — for summary generation
# ==============================================================
#
# These are the thematic tags used in the `area` column above.
# Adjust descriptions as needed; they can drive a narrative
# summary or grouped display.

area_descriptions <- tribble(
  ~area,                                ~description,
  "Quantitative Methods & Statistics",  "Correlational, experimental, and advanced methods including multilevel modeling, longitudinal analysis, SEM, multivariate analysis, and simulation",
  "Psychometrics & Measurement",        "Classical and modern test theory, item response theory, structural equation modeling, measurement evaluation, and assessment of special populations",
  "Research Methods & Design",          "Foundations of educational research, qualitative approaches, survey methodology, and correlational/experimental design",
  "Exercise Science & Physiology",      "Exercise physiology, neuromuscular mechanisms, exercise testing and prescription, environmental physiology",
  "Sport Nutrition & Biochemistry",     "Sport nutrition, dietary supplements, exercise biochemistry, metabolism, and exercise-nutrition interactions",
  "Strength & Conditioning",            "Program design and applied strength and conditioning",
  "Cognitive Science & Development",    "Human cognition and instruction, mind-brain-education, and cognitive development",
  "Computing & Data Science",           "Statistical computing in R, applied multivariate statistics using R, data visualization, and computer-assisted research data analysis",
  "Professional Development",           "Grant writing and directed field experience (practicum)"
)

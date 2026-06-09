# cv_data.R
# Structured CV data for Amelia A. Miramonti
# Sourced by cv.qmd in the setup chunk.
# Edit this file to update CV content; re-render cv.qmd to produce PDF.

library(conflicted)
library(tibble)
library(dplyr)

conflicts_prefer(dplyr::filter, dplyr::select, .quiet = TRUE)

# ==============================================================
# Education
# ==============================================================

education_data <- tribble(
  ~degree                                                                                                                                                                                                                                                                                    , ~institution  , ~location   , ~dates , ~details ,
  "PhD — Interdisciplinary"                                                                                                                                                                                                                                                                  ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                           , "Lincoln, NE" , "2015–2025" ,
  "Quantitative, Qualitative, & Psychometric Methods (Educational Psychology); Human Sciences: Exercise Physiology & Nutrition (Nutrition & Health Sciences). Dissertation: Youth Sport Participation and Cognitive Development: The Need for Improved Measurement. Conferred May 17, 2025." ,

  "MA — Quantitative, Qualitative, and Psychometric Methods"                                                                                                                                                                                                                                 ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                           , "Lincoln, NE" , "2018"      ,
  "Educational Psychology. Thesis: Evaluation of the Feasibility of a Two-Method Measurement Design for the Assessment of Healthy Physical Activity Behavior in Youth."                                                                                                                      ,

  "MSc — Sport & Exercise Science"                                                                                                                                                                                                                                                           ,
  "University of Central Florida"                                                                                                                                                                                                                                                            , "Orlando, FL" , "2013–2015" ,
  "Applied Exercise Physiology Track. Thesis: The Effects of Four Weeks of High-Intensity Interval Training and \\(\\beta\\)-Hydroxy-\\(\\beta\\)-Methylbutyric Free Acid Supplementation on the Onset of Neuromuscular Fatigue."                                                            ,

  "BSc — Sport and Exercise Science"                                                                                                                                                                                                                                                         ,
  "University of Central Florida"                                                                                                                                                                                                                                                            , "Orlando, FL" , "2007–2013" ,
  "Human Performance Specialization."
)

# ==============================================================
# Academic Positions
# ==============================================================
# Each row is one appointment. Use `what` for title, `with` for unit/org,
# `where` for institution, `when` for date range, `why` for description bullets.

positions_data <- tribble(
  ~title                                                                                                                                                                                                                                                                                                                                                                                , ~unit                      , ~institution , ~dates , ~description ,
  "Adjunct Faculty Instructor"                                                                                                                                                                                                                                                                                                                                                          ,
  "Department of Educational Psychology"                                                                                                                                                                                                                                                                                                                                                ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "January 2026–present"     ,
  "EDPS 845 – Computer-Assisted Research Data Analysis (Spring 2026)."                                                                                                                                                                                                                                                                                                                  ,

  "Postdoctoral Researcher"                                                                                                                                                                                                                                                                                                                                                             ,
  "Nebraska Evaluation and Research Center (NEAR Center), Department of Educational Psychology"                                                                                                                                                                                                                                                                                         ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "July 2025–present"        ,
  "Cross-disciplinary appointment integrating research design and methodology, statistics and data science, and public policy. Primary responsibilities include collaborating on funded research projects, contributing to research design, data analysis, and reporting, and supervising graduate students in the Quantitative, Qualitative, and Psychometric Methods (QQPM) program." ,

  "Postdoctoral Research Associate (contracted affiliation)"                                                                                                                                                                                                                                                                                                                            ,
  "Nebraska Statewide Workforce & Educational Reporting System (NSWERS)"                                                                                                                                                                                                                                                                                                                ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "July 2025–present"        ,
  "Creating privacy-preserving synthetic datasets from large-scale, longitudinal administrative data to support public research initiatives."                                                                                                                                                                                                                                           ,

  "Postdoctoral Research Associate (contracted affiliation)"                                                                                                                                                                                                                                                                                                                            ,
  "University of Nebraska Public Policy Center (NUPPC)"                                                                                                                                                                                                                                                                                                                                 ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "July 2025–present"        ,
  "Evaluation and research projects to inform public policy."                                                                                                                                                                                                                                                                                                                           ,

  "Research Coordinator (full-time)"                                                                                                                                                                                                                                                                                                                                                    ,
  "Nebraska Evaluation and Research Center, Department of Educational Psychology"                                                                                                                                                                                                                                                                                                       ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "September 2024–July 2025" ,
  NA_character_                                                                                                                                                                                                                                                                                                                                                                         ,

  "Graduate Research Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Nebraska Evaluation and Research Center, Department of Educational Psychology"                                                                                                                                                                                                                                                                                                       ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "2022–August 2024"         ,
  NA_character_                                                                                                                                                                                                                                                                                                                                                                         ,

  "Graduate Research Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Nebraska Academy for Methodology, Analytics & Psychometrics, Nebraska Center for Research on Children, Youth, Families, & Schools"                                                                                                                                                                                                                                                   ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "2018–2021"                ,
  NA_character_                                                                                                                                                                                                                                                                                                                                                                         ,

  "Graduate Research Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Nebraska Extension — 4-H Youth Development, Institute of Agriculture and Natural Resources"                                                                                                                                                                                                                                                                                          ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "Spring 2018"              ,
  NA_character_                                                                                                                                                                                                                                                                                                                                                                         ,

  "Graduate Research Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Nebraska Extension — Nutrition Education Program/SNAP-Ed, Department of Nutrition & Health Sciences"                                                                                                                                                                                                                                                                                 ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "Fall 2017"                ,
  NA_character_                                                                                                                                                                                                                                                                                                                                                                         ,

  "Graduate Research Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Neuromuscular Research & Imaging Laboratory, Department of Nutrition & Health Sciences"                                                                                                                                                                                                                                                                                              ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "2015–2017"                ,
  NA_character_                                                                                                                                                                                                                                                                                                                                                                         ,

  "Graduate Teaching Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Department of Educational Psychology"                                                                                                                                                                                                                                                                                                                                                ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "Spring 2022"              ,
  "EDPS 459 – Statistical Methods."                                                                                                                                                                                                                                                                                                                                                     ,

  "Graduate Teaching Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Department of Nutrition & Health Sciences"                                                                                                                                                                                                                                                                                                                                           ,
  "University of Nebraska–Lincoln"                                                                                                                                                                                                                                                                                                                                                      , "2015–2017"                ,
  "NUTR 250 – Human Nutrition & Metabolism (Fall 2015, Fall 2016, Spring 2017); NUTR 484 – Physiology of Exercise Laboratory (Spring 2016); NUTR 486 – Exercise Testing & Prescription Laboratory (Spring 2016)."                                                                                                                                                                       ,

  "Graduate Research Assistant"                                                                                                                                                                                                                                                                                                                                                         ,
  "Institute of Exercise Physiology & Wellness, Department of Educational & Human Science"                                                                                                                                                                                                                                                                                              ,
  "University of Central Florida"                                                                                                                                                                                                                                                                                                                                                       , "2013–2015"                ,
  NA_character_                                                                                                                                                                                                                                                                                                                                                                         ,

  "Graduate Teaching Associate"                                                                                                                                                                                                                                                                                                                                                         ,
  "Department of Educational & Human Science"                                                                                                                                                                                                                                                                                                                                           ,
  "University of Central Florida"                                                                                                                                                                                                                                                                                                                                                       , "2014–2015"                ,
  "PEM 2104 Personal Fitness (Summer 2014); PET 3005 Intro to Sport & Exercise Science (Summer 2014, Fall 2014, Spring 2015); PET 4083 Personal Training Methods (Spring 2015)."                                                                                                                                                                                                        ,

  "Research Practicum"                                                                                                                                                                                                                                                                                                                                                                  ,
  "Institute of Exercise Physiology & Wellness, Department of Educational & Human Science"                                                                                                                                                                                                                                                                                              ,
  "University of Central Florida"                                                                                                                                                                                                                                                                                                                                                       , "Fall 2012"                ,
  NA_character_
)

# ==============================================================
# Invited & Guest Lectures
# ==============================================================

lectures_data <- tribble(
  ~title                                                                                                                                                                                     , ~context , ~date ,
  # TODO: add Session 2 of 2 — "Data Wrangling: Organization, Cleaning, Recoding, etc." (same Brown Bagger series) once delivered.
  "Data documentation for Teams (Session 1 of 2)"                                                                                                                                            ,
  "Data Management Brown Bagger Series, University of Nebraska Public Policy Center, Lincoln, NE."                                                                                           ,
  "June 2026"                                                                                                                                                                                ,

  "Interaction Contrasts in ANOVA"                                                                                                                                                           ,
  "Guest lecture, EDPS 941 – Intermediate Statistics: Experimental Methods (Dr. Matt Fritz, instructor), Department of Educational Psychology, University of Nebraska–Lincoln, Lincoln, NE." ,
  "March 26, 2026"                                                                                                                                                                           ,

  "Meeting the Demands of High Intensity Interval Training: Metabolic and Physiological Adaptations to High-Intensity Interval Training"                                                     ,
  "Lecture, 2017 National Strength & Conditioning Association National Conference, symposium sponsored by GNC Nutrition, Inc., Las Vegas, NV."                                               ,
  "July 12–15, 2017"
)

# ==============================================================
# Mentoring
# ==============================================================

mentoring_data <- tribble(
  ~role                    , ~program                                                                    , ~institution                     , ~dates      ,
  "McNair Graduate Mentor" , "Ronald E. McNair Scholars Program"                                         , "University of Nebraska–Lincoln" , "2016–2017" ,
  "UCARE Graduate Mentor"  , "Undergraduate Creative Activities and Research Experience (UCARE) Program" , "University of Nebraska–Lincoln" , "2017"
)

# ==============================================================
# Additional Professional Training
# ==============================================================

training_data <- tribble(
  ~title                                                                                                                      , ~presenter          , ~series             , ~date            ,
  "Regression Discontinuity Designs in Social Science Research: Causal Inference of Cutoff-Based Programs"                    , "HyeonJin Yoon"     , "Nebraska MAP Apps" , "March 2020"     ,
  "Pursuing Causal Inferences in the Absence (or Failure) of Random Assignment: An Introduction to Propensity Score Analysis" ,
  "Natalie Koziol"                                                                                                            , "Nebraska MAP Apps" , "February 2020"     ,
  "Improving Data Quality Through Qualtrics Survey Design"                                                                    , "Jared Stevens"     , "Nebraska MAP Apps" , "February 2019"  ,
  "Addressing One Research Question Using Multiple Methodological Approaches"                                                 , "Marc Goodrich"     , "Nebraska MAP Apps" , "April 2019"     ,
  "Time is on my side: What British rock bands can teach us about designing longitudinal studies"                             , "Matt Fritz"        , "Nebraska MAP Apps" , "February 2018"  ,
  "An Introduction to Machine Learning"                                                                                       , "Stephen Scott"     , "Nebraska MAP Apps" , "November 2017"  ,
  "Evidence-Based Assessment: From simple clinical judgments to statistical learning"                                         , "Eric Youngstrom"   , "Emerging Scholars" , "April 2018"     ,
  "Does Model Fit have a Validity Problem?"                                                                                   , "Mike Edwards"      , "Emerging Scholars" , "September 2017" ,
  "Training and Assessing Communication Skills Using Virtual Human Technology"                                                , "Tim Guetterman"    , "Emerging Scholars" , "April 2019"
)

# ==============================================================
# Professional Service
# ==============================================================

service_data <- tribble(
  ~role                                     , ~organization                                   , ~dates         ,
  "Conference Abstract Reviewer"            , "National Strength & Conditioning Association"  , "2016, 2019"   ,
  "Reviewer"                                , "Journal of Strength and Conditioning Research" , "2016–2020"    ,
  "Reviewer"                                , "Research Quarterly for Exercise and Sport"     , "2019–2020"    ,
  "Reviewer"                                , "Women in Sport and Physical Activity Journal"  , "2026–present" ,
  "Graduate Student Volunteer Poster Judge" , "UNL CEHS Undergraduate Research Fair"          , "2019"
)

# ==============================================================
# Professional Associations
# ==============================================================

associations_data <- tribble(
  ~organization                                                       , ~membership   , ~dates         ,
  "American Psychological Association"                                , "Member"      , "2024–2025"    ,
  "American Statistical Association"                                  , "Member"      , "2019–2020"    ,
  "Society for Openness, Transparency and Replication in Kinesiology" , "Member"      , "2019–present" ,
  "National Strength & Conditioning Association"                      ,
  "Member, 2014–2020; Research Consortium Member, 2019–2020"          , NA_character_ ,
  "American College of Sports Medicine"                               , "Member"      , "2013–2020"    ,
  "National Intramural Recreational Sports Association"               , "Member"      , "2009–2010"
)

# ==============================================================
# Professional Credentials
# ==============================================================

credentials_data <- tribble(
  ~credential                                            , ~organization                                  , ~status   ,
  "Certified Strength & Conditioning Specialist"         , "National Strength & Conditioning Association" , "Expired" ,
  "Adult CPR/AED, Child CPR and First Aid Certification" , "American Red Cross"                           , "Expired"
)

# ==============================================================
# Awards, Fellowships & Scholarships
# ==============================================================

awards_data <- tribble(
  ~award                                              , ~organization                                                          , ~dates       ,
  "Plake Fellowship"                                  , "Department of Educational Psychology, University of Nebraska–Lincoln" , "2024"       ,
  "AAUW Fellowship"                                   , "American Association of University Women, Lincoln, NE Chapter"        , "2019–2020"  ,
  "Women's Scholarship"                               , "National Strength & Conditioning Association"                         , "2016, 2017" ,
  "Othmer Fellowship"                                 , "University of Nebraska–Lincoln"                                       , "2015–2018"  ,
  "Graduate Research Excellence Fellowship"           , "University of Central Florida"                                        , "2014–2015"  ,
  "Pegasus Scholarship"                               , "University of Central Florida"                                        , "2007–2010"  ,
  "Finalist — National Merit Scholarship Competition" , NA_character_                                                          , "2007"
)

# ==============================================================
# Online Profiles
# ==============================================================

profiles_data <- tribble(
  ~platform        , ~url                                                            ,
  "Google Scholar" , "https://scholar.google.com/citations?hl=en&user=AcbJlasAAAAJ"  ,
  "LinkedIn"       , "https://www.linkedin.com/in/amelia-miramonti/"                 ,
  "ResearchGate"   , "https://www.researchgate.net/profile/Amelia-Miramonti"         ,
  "ORCiD"          , "https://orcid.org/0000-0002-0277-4064"                         ,
  "GitHub"         , "https://github.com/amelia-m"                                   ,
  "OSF"            , "https://osf.io/zk8rv/"                                         ,
  "Lens"           , "https://www.lens.org/lens/profile/528341700/scholar"           ,
  "Scopus"         , "https://www.scopus.com/authid/detail.uri?authorId=56123562400"
)

# ==============================================================
# Technical Skills — Laboratory Assessments
# ==============================================================

lab_skills <- c(
  "Heart rate (Polar monitors), blood pressure, anthropometrics",
  "Resting metabolic rate and maximal oxygen uptake (ParvoMedics TrueOne 2400, Sensormedics Vmax Encore); Wingate and 3-minute critical power testing (Lode Corrival cycle ergometer)",
  "Isometric, isokinetic, and isotonic strength testing (Biodex System)",
  "Electromyographic and mechanomyographic data collection and processing (Noraxon Desktop DTS, Biopac)",
  "Sport performance testing — sprints, agility, jumps, and force plate assessments using custom LabVIEW data collection interfaces",
  "Physical activity monitoring (Actigraph wGT3X-BT)",
  "Finger prick blood sample collection, basic sample processing"
)

# ==============================================================
# Technical Skills — Software & Computing
# ==============================================================

software_dev_data <- tribble(
  ~name                          , ~when      , ~role                              , ~description ,
  "Recode Studio"                , "Ongoing"  , "Author & maintainer — R / Shiny"  ,
  "Dataset-agnostic R/Shiny app for cleaning messy string variables without hand-writing R: browse values, flag likely typos via spellcheck, build and preview recode rules, and export both a reusable rule set and runnable R code. Open source: github.com/amelia-m/recode-studio" ,
  "Table Relationship Explorer"  , "Ongoing"  , "Author & maintainer — R / Shiny"  ,
  "Interactive tool for discovering and visualizing primary/foreign-key relationships across tabular data: multi-signal key inference with confidence scoring, interactive entity-relationship diagrams, and exportable reports across many file and database formats (with a Python/Streamlit port). Open source: github.com/amelia-m/table-explorer"
)

software_data <- tribble(
  ~category                                                                                                                                                                                                                 , ~tools ,
  "Statistical & Psychometric"                                                                                                                                                                                               ,
  "R Statistical Software (tidyverse; lavaan and related psychometric packages; tidysynthesis and syntheval for synthetic data generation and evaluation); Mplus; SAS; SPSS (including PROCESS macro); MATLAB; Jamovi; JASP" ,
  "Data Collection & Signal Processing"                                                                                                                                                                                      ,
  "LabVIEW (data collection, signal processing, and analysis); Biopac (EMG/MMG data collection)"                                                                                                                             ,
  "Survey & Data Management"                                                                                                                                                                                                 ,
  "Qualtrics; REDCap"                                                                                                                                                                                                        ,
  "Reproducible Research & Reference Management"                                                                                                                                                                             ,
  "Quarto / R Markdown; Markdown; LaTeX / TinyTeX; targets (R package for reproducible pipelines); Obsidian; Zotero; Open Science Framework (OSF)"                                                                           ,
  "Development Environments & Editors"                                                                                                                                                                                       ,
  "Positron; RStudio; Visual Studio Code; Notepad++"                                                                                                                                                                         ,
  "LLM-Assisted Development"                                                                                                                                                                                                 ,
  "Claude Code; Gemini / Gemini CLI; GitHub Copilot"                                                                                                                                                                         ,
  "Programming & Version Control"                                                                                                                                                                                            ,
  "GitHub / Git; Python; Unix / Bash"                                                                                                                                                                                        ,
  "Visualization"                                                                                                                                                                                                            ,
  "ggplot2 (R); Shiny (R); gt / gtsummary (R); kableExtra (R); LabVIEW; Veusz"                                                                                                                                               ,
  "Productivity & Collaboration"                                                                                                                                                                                             ,
  "Microsoft Office Suite (Excel, PowerPoint, Word, Access, Teams, SharePoint); Adobe Acrobat Pro DC; Adobe Illustrator"
)

# ==============================================================
# Languages
# ==============================================================

languages_data <- tribble(
  ~language , ~proficiency   ,
  "German"  , "~30% fluency" ,
  "Italian" , "~55% fluency"
)

# ==============================================================
# Manuscripts in Progress
# ==============================================================
# Lifecycle tracking for work NOT yet detectable via Scholar/ORCID.
# update_bib.R Section 6 audits this table on every run:
#   - flags rows whose status_date is older than 60 days (or NA)
#     as NEEDS STATUS CHECK
#   - cross-references titles against fetched Scholar/ORCID results;
#     a match means the paper is now public --> promote it to
#     bib/publications.bib and DELETE the row here
#
# Columns:
#   status      -- one of manuscript_statuses (rendered on CV as-is)
#   journal     -- target journal; internal unless the
#                  show_manuscript_journals param is TRUE in cv.qmd
#   submitted   -- "YYYY-MM-DD" submitted to current journal (NA if
#                  not yet submitted); internal, never rendered
#   status_date -- "YYYY-MM-DD" the status was last VERIFIED
#                  (drives the 60-day staleness check); internal
#   notes       -- internal notes; never rendered

manuscript_statuses <- c(
  "In progress",
  "Under review",
  "Revise & Resubmit",
  "Accepted"
)

manuscripts_data <- tribble(
  ~authors                                                                                                                                                                       , ~title , ~status , ~journal , ~submitted , ~status_date , ~notes ,
  "Miramonti AA, Jeffries J, Riley JH, Bovaird JA"                                                                                                                               ,
  "Completeness Thresholds Matter in Person-Mean Imputation and Prorated Scale Score Methods"                                                                                    ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
  "Jeffries J, Miramonti AA, Riley JH, Bovaird JA"                                                                                                                               ,
  "Untangling single imputation methods: A focus on person-mean imputation and prorated scale scores"                                                                            ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
  "Miramonti AA, Bovaird JA, Krehbiel M, Franzen-Castle L"                                                                                                                       ,
  "Evaluation of the feasibility of a two-method measurement design for the assessment of healthy physical activity behavior in youth"                                           ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
  "Miramonti AA, Pense SM, Rida Z, Fischer JA, Bovaird JA"                                                                                                                       ,
  "School Administrator Perceptions of the School Breakfast Program in Nebraska"                                                                                                 ,
  "Revise & Resubmit"                                                                                                                                                            ,
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
  "Miramonti AA, Pense SM, Rida Z, Fischer JA, Bovaird JA"                                                                                                                       ,
  "Parent Perceptions of the School Breakfast Program in Nebraska"                                                                                                               ,
  "Revise & Resubmit"                                                                                                                                                            ,
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
  "Miramonti AA, Jenkins NDM, Gillen ZM"                                                                                                                                         ,
  "Electromyographic and mechanomyographic amplitude patterns of responses during isometric versus concentric dynamic constant external resistance leg extension muscle actions" ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
  "Fukuda DH, Stout JR, Robinson EH, Wang R, Mangine GT, Miramonti AA, Fragala MS, Hoffman JR"                                                                                   ,
  "Improved critical power and muscle cross-sectional area following a progressive 4-week cycling interval training program in men and women"                                    ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , NA_character_ , NA_character_ ,
  "Santos N, Miramonti AA, Fox G, Abresch C, Franzen-Castle L"                                                                                                                   ,
  "Latino Consumer Food Environments: A cross-sectional analysis of rural food retailers"                                                                                        ,
  "Under review"                                                                                                                                                                 ,
  "Nutrition & Dietetics"                                                                                                                                                        , "2026-05-28" , "2026-06-08" , "Manuscript ID 4212250; ORCID co-author verification" ,
  "Vargas J, Miramonti AA, Abbott D"                                                                                                                                             ,
  "The Role of Motivated Cognition in Transphobia: Need for Closure, Gender Essentialism, and Intergroup Contact"                                                                ,
  "Under review"                                                                                                                                                                 ,
  "Sex Roles"                                                                                                                                                                    , "2026-06-02" , "2026-06-08" , "Submission ID 3d1fd576-28b8-435c-9741-007d154a60ab; co-author" ,
  "Yang Z, Miramonti AA, Choi JK, Jiang Q, Wang D"                                                                                                                               ,
  "Validation of the HOME Inventory's Time Invariance in FFCWS: Insights into Home Environment Changes in Disadvantaged Parents Over a Decade"                                   ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , "2026-06-08" , NA_character_ ,
  "Rasby S, Miramonti AA, Wilhite H"                                                                                                                                             ,
  "“It helps me deal with what's happening right now instead of letting my emotions get out of control.” Exploring a Self-Compassion Group for Family Caregivers"     ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , "2026-06-08" , "Tentative author list" ,
  "Albert R, Beeghly MJ, Brophy-Herb H, Gardner-Neblett N, Miramonti AA, Torquati J, Vallotton C"                                                                                ,
  "Racial and Gender Biases in Interpretations of Typical Infant/Toddler Behaviors"                                                                                             ,
  "In progress"                                                                                                                                                                  ,
  NA_character_                                                                                                                                                                  , NA_character_ , "2026-06-08" , "Working title; author order undetermined, listed alphabetically"
)

# ==============================================================
# Preprints / OSF Works
# ⚠️ Confirm section placement and authorship before v1.0.0
# ==============================================================

preprints_data <- tribble(
  ~authors                                                                                                  , ~title            , ~repository             , ~date , ~doi ,
  "Wick K, Miramonti AA, et al."                                                                            ,
  "The persistence of faculty mentorship as a robust correlate of positive outcomes in university students" ,
  "OSF Preprint"                                                                                            , "October 2, 2024" , "10.17605/osf.io/m3rpv"
)

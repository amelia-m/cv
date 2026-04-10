# render.R
# Run this from the Positron R console to build the CV PDF.
# (Quarto CLI cannot render vitae directly; use rmarkdown::render() instead.)

rmarkdown::render("cv.qmd", output_dir = "output")

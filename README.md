# Kew_WCoUP_ProcessoR

Version 0.1.0 (March 2021, April 2022)

Made possible by Idaho EPSCoR GEM3

https://www.idahogem3.org/

# License
© 2021 J. M. A. Wojahn, S. Buerki GNU General Public License v. 3

https://www.gnu.org/licenses/gpl-3.0.en.html

# What it does
A function that extracts and sorts information from the "Kew World Checklist of  Useful Plants", which is available only in PDF format.

Output is a data.frame with three columns: "Species","Authority", and "Uses"

# Use
The function has two arguments: 

pathway: which is the reletive or full path to the Kew WCoUP PDF file

InstallDs, which can be set to T if you need to install devtools and tabulizer, or F if you already have them installed

The function is run thusly, with the output set to an object:

source("Path/To/Kew_WCoUP_ProcessoR.R")

KewWCoUP_Data <- Kew_WCoUP_ProcessoR(pathway = "Path/To/File.pdf", InstallDs = T)

# How to cite this function
John M. A. Wojahn and Sven Buerki (2021) Kew_WCoUP_ProcessoR: a function that extracts and sorts information from the Kew World Checklist of  Useful Plants, which is available only in PDF format. R function version 0.1.0. https://github.com/wojahn/Kew_WCoUP_ProcessoR

# Dependancies
This package depends on devtools and tabulizer.

# Citations
Hadley Wickham, Jim Hester, Winston Chang and Jennifer
  Bryan (2021). devtools: Tools to Make Developing R
  Packages Easier. R package version 2.4.3.
  https://CRAN.R-project.org/package=devtools

Thomas J. Leeper (2018). tabulizer: Bindings for Tabula PDF
  Table Extractor Library. R package version 0.2.2.

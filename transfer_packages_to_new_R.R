
## 1) run this in OLD version of R ##
setwd("/home/nathan/Documents")
packages <- installed.packages()[,"Package"]

#optional: packages to exclude from new version
# exclude <- (packages %in% c("R2WinBUGS","R2OpenBUGS"))==FALSE
# packages <- packages[exclude]

save(packages, file="Rpackages_temp")


## 2) run this in NEW version of R ##
setwd("/home/nathan/Documents")
load("Rpackages_temp")
for (p in setdiff(packages, installed.packages()[,"Package"]))
  install.packages(p)

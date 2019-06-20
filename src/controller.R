##### Test parallel processing on at the subroutine inside runModelSet
# Author: Katherine Lauck
# Last updated: 12 November 2018
#
# To use this script, run occModInputs.R, which creates
# the source occupancy data for the analyses carried out by this script.
#
# To change the survey covariates available, modify surveyCov.R, and to change
# the site covariates, modify unitCov.R. Make sure you understand the required
# format for both covariate types.
#

# Initialization

source("src/SETTINGS.R")
source("src/functions.R")

# If desired, you can recreate the input from scratch:
#source('src/occModInputs.R')

 # import input files depending on whether this analysis will use dummy or normal
# dataset
importInput(DATASET)
occ.data <- makeFilenameVector(SPECIES_TO_BE_ANALYZED,DATASET)
names <- SPECIES_TO_BE_ANALYZED


# test: one species with parallel processing runModelSet
runModelSet(paste0(INPUT_DIRECTORY,"/dummyHistories/Alcippe brunneicauda.csv"),
            destination = OUTPUT_DIRECTORY,
            #site.cov = unit.cov.dummy[,c(1,2,5:8)], # drop grass and shrubs
            survey.cov = survey.cov.dummy,
            point.names = unlist(point.dummy,use.names = FALSE),
            focus.param = "p")
brFul <- readRDS(paste0(OUTPUT_DIRECTORY,"/Alcippe brunneicauda/Alcippe brunneicaudaAIC.rds"))
brFulEvidence <- summedWgt(names(survey.cov.dummy),param = "p",brFul)

## all species with only survey covariates - later survey models for each
## species will be defined
unlink(paste0(OUTPUT_DIRECTORY,'/survey'),recursive = T) # remove previous fill
dir.create(paste0(OUTPUT_DIRECTORY,'/survey'))  # create directory
results.spp.p <- lapply(occ.data,
                        runModelSet,
                        site.cov = site.cov.dummy,
                        destination = paste0(OUTPUT_DIRECTORY,"/survey"),
                        survey.cov = survey.cov.dummy,
                        point.names = unlist(point.dummy,use.names = FALSE),
                        #cl = cl,
                        #type = "so",
                        focus.param = "p"
                        )
names(results.spp.p) <- names

## Model selection- save p structures with delta-AIC less than 10

# list and import summaries of AIC tables
aic.table.files <- list.files(path = "/Volumes/GoogleDrive/My Drive/occupancyOutput/pOnly",
                         pattern = ".*(AICsum\\.csv)$",
                         recursive = T,
                         full.names = T
)
aic.tables <- lapply(aic.table.files,
                     import)

# build list of p structures with delta AIC<10 for each species
p.models <- lapply(aic.tables,
                   function(x) return(sub("(psi\\(\\))$","",x$Model[which(x$DAIC<10)])))



# turn character vectors of models into
p.form <- lapply(p.models,
                 function(x) return(lapply(x,
                                           make.formula,
                                           param = "p")))
names(p.form) <- names

# one species test
runModelSet("/Volumes/GoogleDrive/My Drive/CAGN occupancy/Analysis/R/Rpresence/dummyHistories/Alcippe brunneicauda.csv",
            destination = "/Volumes/GoogleDrive/My Drive/occupancyOutput/habitat",
            site.cov = unit.cov.dummy[,c(1:5,8,10:12)], # drop anthro factors
            survey.cov = survey.cov.dummy,
            point.names = unlist(point.dummy,use.names = FALSE),
            focus.param = "psi",
            p.model = p.form)

# all species habitat output
results.spp.habitat <- lapply(occ.data,
                        runModelSet,
                        site.cov = unit.cov.dummy[,c(1:5,8,10:12)], # drop anthro factors
                        destination = "/Volumes/GoogleDrive/My Drive/occupancyOutput/habitat",
                        survey.cov = survey.cov.dummy,
                        point.names = unlist(point.dummy,use.names = FALSE),
                        #cl = cl,
                        #type = "so",
                        focus.param = "psi",
                        p.model = p.form
)


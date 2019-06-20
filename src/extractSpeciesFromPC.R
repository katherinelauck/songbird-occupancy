# Extract point count data for specific species
# Author: Katherine Lauck
# 19 June 2019
#
# Extract point count data for several species.
#
#Change import/export directories in file below
source('G:/My Drive/projects/songbird-occupancy/src/SETTINGS.R')

pc <- import(paste0(INPUT_DIRECTORY,'/pointCountMaster.csv')) #import master
#source(paste0(PROJECT_DIRECTORY,'/src/buildDetectionHistories.R')) #rebuild master

species <- list('Copsychus malabaricus', # list of species. Can add/subtract, 
                'Berenicornis comatus',  # use comma to separate
                'Anorrhinus galeritus',
                'Anthracoceros albirostris',
                'Anthracoceros malayanus',
                'Buceros rhinoceros',
                'Rhinoplax vigil',
                'Rhabdotorrhinus corrugatus',
                'Rhyticeros undulatus',
                'Chloropsis sonnerati')

spp.subset <- pc[which(pc$species %in% species),]

export(spp.subset,paste0(PROJECT_DIRECTORY,'/results/data/PCsubsetForAdam.csv'))

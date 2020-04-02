# script to visualize divergence trajectories
rm(list = ls())
sourceDir <- "~/Documents/Research/SpeciationGenomics/CriticalTransitionsWithVasilis/"
setwd(sourceDir)
baseDirs <- c("AbruptRuns", "GradualRuns", "NeutralRuns")
dirNames <- paste("RunsFromHD2/", baseDirs, "/", sep = "")

#######################################################
# unzip the data on Effective Migration Rates if needed
#######################################################
count <- 0
for ( i in dirNames ) {
  # go to directory:
  setwd(i)
  # get list of dirs there:
  dirList <- system("ls", intern = T)
  for ( j in dirList ) {
    fname <- paste(j, "/EffectiveMigrationRates.txt.bz2", sep = "")
    fname2 <- paste(j, "/EffectiveMigrationRates.txt", sep = "")
    print(fname)
    if ( file.exists( fname ) ) {
      print('hi')
      msg <- system( paste("bunzip2", fname), intern = T)
      print(msg)
    } else if ( file.exists(fname2) ) {
      print("It's here and unzipped!")
      count <- count + 1
    }
  }
  
  setwd(sourceDir)
}
print(paste("Unzipped count = ", count))


###############################################
## Import data
###############################################

# get total line counts:
wcs <- rep(0, length(dirNames))
for ( i in 1:length(wcs) ) {
  parentDir <- dirNames[ i ]
  wcs[i] <- as.numeric( system(paste("wc -l ", parentDir, "*/EffectiveMigrationRates.txt", " | tail -n 1 | awk ' {print $1} '", sep = ""), intern = T) )
}
wcs
totalLines <- sum(wcs)
# preallocate using total line counts:
RunIndex <- rep("", totalLines)
Generation <- rep(0, totalLines)
EffMig <- Generation
Category <- rep("", totalLines)
AllEffMigRates <- data.frame( RunIndex, Generation, EffMig, Category, stringsAsFactors = F )
catIndex <- 1
rowCount <- 1
for ( i in 1:length(wcs) ) {
  AllEffMigRates$Category[ catIndex:(catIndex + wcs[i] - 1) ] <- rep( baseDirs[i], wcs[i] )
  catIndex <- catIndex + wcs[i]
  parentDir <-  dirNames[i]
  runDirsHere <- system(paste("ls", parentDir), intern = T)
  nDirsHere <- length(runDirsHere)
  for ( j in 1:nDirsHere ) {
    fname <- paste(parentDir, runDirsHere[j], "/EffectiveMigrationRates.txt", sep = "")
    # Eff mig rates are second column; time is first
    effMigData <- read.table(file = fname, sep = " ", stringsAsFactors = F, header = F)[ , 1:2]
    nRowsHere <- nrow(effMigData)
    fillThese <- rowCount:(rowCount + nRowsHere - 1)
    AllEffMigRates$RunIndex[fillThese] <- runDirsHere[j]
    AllEffMigRates$Generation[fillThese] <- effMigData$V1
    AllEffMigRates$EffMig[fillThese] <- effMigData$V2
    rowCount <- rowCount + nRowsHere
  }
  
}
head(AllEffMigRates)
tail(AllEffMigRates)

require(ggplot2)

# remove zeros for log transform:
zeroEffMig <- AllEffMigRates$EffMig == 0
EffMigDataPlot <- AllEffMigRates[ !zeroEffMig,  ]

#smallData <- AllEffMigRates[c(1:1000, 20000:21000), ]
ggplot( data = EffMigDataPlot ) +
  geom_line( mapping = aes( x = Generation, y = EffMig, color = RunIndex ) ) + 
  facet_wrap( ~Category, scales = "free_x")  + 
  scale_y_log10() + 
  theme( legend.position = "none ")


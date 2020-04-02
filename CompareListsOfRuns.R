# Comparing Runs on Old Hard Drives from BU2S model
rm(list = ls())
FromHD1 <- read.csv("~/Documents/Research/SpeciationGenomics/bu2s/bu2s_neutral_runs/FromOldHardDrives/From_SG4TB1-bu2sneutral/RunSummary_200002-203930 (1).csv", stringsAsFactors = F)
FromHD2 <- read.csv("~/Documents/Research/SpeciationGenomics/bu2s/bu2s_neutral_runs/FromOldHardDrives/From_4TB_USB_SG2/RunSummary_102431-206600.csv", stringsAsFactors = F)
all(names(FromHD1) == names(FromHD2))

nrow(FromHD1)
nrow(FromHD2)

# Overlaps:
RunsInBoth <- intersect(FromHD1$run_index, FromHD2$run_index)
nIntersect <- length(RunsInBoth)

keepRowsFromHD1 <- FromHD1$run_index %in% RunsInBoth
FromHD1overlap <- FromHD1[keepRowsFromHD1, ]
keepRowsFromHD2 <- FromHD2$run_index %in% RunsInBoth
FromHD2overlap <- FromHD2[keepRowsFromHD2, ]
# check for equality in overlapping runs:
all(FromHD1overlap == FromHD2overlap)

# They aren't the same.  Which are the same and which different?
sameIndexes <- rep(0, nIntersect)
diffIndexes <- sameIndexes # preallocation

sameCount <- 0
diffCount <- 0
for ( i in 1:nIntersect ) {
  wi <- RunsInBoth[i]
  rowHD1 <- FromHD1[ FromHD1$run_index == wi, ]
  rowHD2 <- FromHD2[ FromHD2$run_index == wi, ]
  if ( length(rowHD1) == length(rowHD2) ) {
    if ( all(rowHD1 == rowHD2) ) {
      sameCount <- sameCount + 1
      sameIndexes[sameCount] <- wi
    } else {
      diffCount <- diffCount + 1
      diffIndexes[ diffCount ] <- wi
    }
  } else {
    diffCount <- diffCount + 1
    diffIndexes[ diffCount ] <- wi
  }
}

if ( sameCount < nIntersect )
  sameIndexes <- sameIndexes[ -((sameCount+1):nIntersect) ]
if ( diffCount < nIntersect )
  diffIndexes <- diffIndexes[ -((diffCount+1):nIntersect) ]

sameCount
diffCount

if ( sameCount == 0 ) {
  cat("\nALL runs are different!!\n")
}


## Since all runs are different:
FromHD1$hdsource <- "HD1"
FromHD2$hdsource <- "HD2"

allData <- rbind(FromHD1, FromHD2 )

summary(allData$MEAN_S)
hist(allData$MEAN_S)
summary(allData$SD_MOVE)
hist(allData$SD_MOVE)

require(dplyr)
s_vals_freqs <- allData %>% 
  group_by( MEAN_S ) %>% 
  summarize( Freq = n() ) %>% 
  arrange( desc(Freq) )
head(s_vals_freqs)

m_vals_freqs <- allData %>% 
  group_by( SD_MOVE ) %>% 
  summarize( Freq = n() ) %>% 
  arrange( desc(Freq) )
head(m_vals_freqs)

m_and_s_vals_freqs <- allData %>% 
  group_by( MEAN_S, SD_MOVE ) %>% 
  summarize( Freq = n() ) %>% 
  arrange( desc(Freq) )
print(m_and_s_vals_freqs, n = 30)

# So, we have lots of combos for the following:
# Should be abrupt divergence: s = 0.02, m = 0.1, 1021 runs
# Should be gradual divergence: s = 0.02, m = 0.001, 210 runs
# Should be gradual divergence: s = 0.01, m = 0.001, 200 runs
# Should be NO divergence: 23  0     0.0001      40
#       24  0     0.001       40
#       25  0     0.01        40
#       26  0     0.1         40
#       27  0     0.00001     33
#       28  0     0.000001    30

m_and_s_more <- allData %>% 
  group_by( MEAN_S, SD_MOVE, INITIAL_POPULAION_SIZE, END_PERIOD_ALLOPATRY, MUTATIONS_PER_GENERATION, hdsource ) %>% 
  summarize( Freq = n() ) %>% 
  arrange( desc(Freq) )
print(m_and_s_more[m_and_s_more$END_PERIOD_ALLOPATRY == -1, ], n = 100)

# indexes of that one to check out:
# abrupt: 7, 11, 
# gradual: 8
# none, neutral: 31, 35, 39
redo <- FALSE  # put in as a safety to avoid overwriting unless we really want to overwrite
setwd("~/Documents/Research/SpeciationGenomics/bu2s/bu2s_neutral_runs/FromOldHardDrives/")
if ( redo ) {
  abruptCombos <- (m_and_s_more[m_and_s_more$END_PERIOD_ALLOPATRY == -1, ])[c(7,11), ]
  gradualCombo <- (m_and_s_more[m_and_s_more$END_PERIOD_ALLOPATRY == -1, ])[8, ]
  neutralCombos <- (m_and_s_more[m_and_s_more$END_PERIOD_ALLOPATRY == -1, ])[c(31,35,39), ]
  write.csv(x = abruptCombos, file = "AbruptParameterCombinations.csv", row.names = F)
  write.csv(x = gradualCombo, file = "GradualParameterCombinations.csv", row.names = F)
  write.csv(x = neutralCombos, file = "NeutralParameterCombinations.csv", row.names = F)
} else {
  abruptCombos <- read.csv("AbruptParameterCombinations.csv", stringsAsFactors = F)
  gradualCombo <- read.csv("GradualParameterCombinations.csv", stringsAsFactors = F)
  neutralCombos <- read.csv("NeutralParameterCombinations.csv", stringsAsFactors = F)
}



# Function to subset by the variables I used
getCombosIwant <- function( combo, allData ) {
  keepRows <- (allData$MEAN_S %in% combo$MEAN_S & 
                 allData$SD_MOVE %in% combo$SD_MOVE & 
                 allData$INITIAL_POPULAION_SIZE %in% combo$INITIAL_POPULAION_SIZE &
                 allData$END_PERIOD_ALLOPATRY %in% combo$END_PERIOD_ALLOPATRY &
                 allData$MUTATIONS_PER_GENERATION %in% combo$MUTATIONS_PER_GENERATION &
                 allData$hdsource %in% combo$hdsource)
  
  return ( allData[keepRows, ] )
}

# make three subsets for our purposes:
abruptRows <- getCombosIwant( abruptCombos, allData )
gradualRows <- getCombosIwant( gradualCombo, allData )
neutralRows <- getCombosIwant( neutralCombos, allData )

redo <- FALSE
if ( redo ) {
  write.csv(abruptRows, "AbruptRuns.csv", row.names = F)
  write.csv(gradualRows, "GradualRuns.csv", row.names = F)
  write.csv(neutralRows, "NeutralRuns.csv", row.names = F)
}

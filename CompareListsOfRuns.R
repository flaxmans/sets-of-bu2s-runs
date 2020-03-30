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

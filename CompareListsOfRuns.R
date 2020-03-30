# Comparing Runs on Old Hard Drives from BU2S model

FromHD1 <- read.csv("~/Documents/Research/SpeciationGenomics/bu2s/bu2s_neutral_runs/FromOldHardDrives/From_SG4TB1-bu2sneutral/RunSummary_200002-203930 (1).csv", stringsAsFactors = F)
SmallerSummaryHD1 <- read.csv("~/Documents/Research/SpeciationGenomics/bu2s/bu2s_neutral_runs/FromOldHardDrives/From_SG4TB1-bu2sneutral/RunParamSummary_200002-202550.csv", stringsAsFactors = F)
FromHD2 <- read.csv("~/Documents/Research/SpeciationGenomics/bu2s/bu2s_neutral_runs/FromOldHardDrives/From_4TB_USB_SG2/RunSummary_102431-206600.csv", stringsAsFactors = F)
SmallerSummaryHD2 <- read.csv("~/Documents/Research/SpeciationGenomics/bu2s/bu2s_neutral_runs/FromOldHardDrives/From_4TB_USB_SG2/ParameterSummaryOfRuns.csv", stringsAsFactors = F)
all(names(FromHD1) == names(FromHD2))

nrow(FromHD1)
nrow(FromHD2)
length(intersect(FromHD1$run_index, FromHD2$run_index))

nrow(SmallerSummaryHD1)
nrow(SmallerSummaryHD2)
length(intersect(FromHD1$run_index, SmallerSummaryHD1$run_index))
length(intersect(FromHD2$run_index, SmallerSummaryHD2$run_index))
all( SmallerSummaryHD1$run_index %in% FromHD1$run_index)
all(FromHD2$run_index == SmallerSummaryHD2$run_index)
print("These calls show that the 'Smaller' objects are contained within the larger")


# Overlaps:
RunsInBoth <- intersect(FromHD1$run_index, FromHD2$run_index)
keepRowsFromHD1 <- FromHD1$run_index %in% RunsInBoth
FromHD1overlap <- FromHD1[keepRowsFromHD1, ]
keepRowsFromHD2 <- FromHD2$run_index %in% RunsInBoth
FromHD2overlap <- FromHD2[keepRowsFromHD2, ]
# check for equality in overlapping runs:
all(FromHD1overlap == FromHD2overlap)
nOverlap <- length( RunsInBoth )
myNames <- names(FromHD1)
for ( i in 1:nOverlap ) {
  r1 <- FromHD1overlap[i, ]
  r2 <- FromHD2overlap[i, ]
  if ( any(r1 != r2) ){
    badCols <- (r1 != r2)
    if ( i == 1 ) {
      oldCols <- badCols
    }
    if ( length(badCols) != length(oldCols) ) {
      cat(paste("\nDifferent columns in RunsInBoth(", i, ") = ", RunsInBoth[i], "!\n\tbadCols = "))
      cat(myNames[badCols])
      cat(", but \n\toldCols = ")
      cat(myNames[oldCols])
      cat("\n")
      break
    } else if ( any(badCols != oldCols) ) {
      cat(paste("\nDifferent columns in RunsInBoth(", i, ") = ", RunsInBoth[i], "!\n\tbadCols = "))
      cat(myNames[badCols])
      cat(", but \n\toldCols = ")
      cat(myNames[oldCols])
      cat("\n")
      break
    } 
    # badNames <- names(FromHD1overlap)[badCols]
    # badr1 <- r1[badCols]
    # badr2 <- r2[badCols]
    # noMatch <- as.data.frame(rbind(badr1, badr2))
    # names(noMatch) <- badNames
    # print(noMatch)
    # break
    oldCols <- badCols
  }
}

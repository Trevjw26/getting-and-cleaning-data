library(tidyverse)
> load_x <- function(target) {
+     
+     # Specify paths to features list and X_train data
+     datadir <- "UCI HAR Dataset"
+     featurefile <- file.path(datadir, "features.txt")
+     x_file <- file.path(
+         datadir,
+         target,
+         sprintf("X_%s.txt", target)
+     )
+     
+     # Load the x dataset using features as column names
+     features <- read_delim(
+         featurefile,
+         delim = " ",
+         col_names = c("idx", "feature"),
+         col_types = list(idx = "i", feature = "c")
+     )
+     dset <- readr::read_fwf(x_file, col_types = "d")
+     names(dset) <- features$feature
+     dset
+ }
> 
> load_y <- function(target) {
+     
+     # Specify paths to features list and X_train data
+     datadir <- "UCI HAR Dataset"
+     featurefile <- file.path(datadir, "activity_labels.txt")
+     y_file <- file.path(
+         datadir,
+         target,
+         sprintf("y_%s.txt", target)
+     )
+     subject_file <- file.path(
+         datadir,
+         target,
+         sprintf("subject_%s.txt", target)
+     )
+     
+     # Load the y and subject datasets
+     labels <- read_delim(
+         featurefile,
+         delim = " ",
+         col_names = c("idx", "activity"),
+         col_types = list(idx = "i", activity = "c")
+     )
+     y_dset <- readr::read_fwf(y_file, col_types = "i")
+     subject_dset <- readr::read_fwf(subject_file, col_types = "i")
+     dset <- dplyr::bind_cols(y_dset, subject_dset)
+     names(dset) <- c("idx", "subject")
+     dplyr::inner_join(dset, labels, "idx")
+ }
> 
> create_tidy_dataset <- function() {
+     
+     # Download the dataset if it hasn't already been downloaded
+     if (!file.exists("UCI HAR Dataset")) {
+         print("Downloading and decompressing UCI HAR Dataset...")
+         zipurl <- paste(
+             "https://d396qusza40orc.cloudfront.net/",
+             "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
+             sep = ""
+         )
+         zipfile <- "target.zip"
+         download.file(zipurl, zipfile)
+         unzip(zipfile)
+         file.remove(zipfile)
+     }
+     
+     ## 1. Merge training and test into one dataset
+     x_train <- load_x("train")
+     x_test <- load_x("test")
+     x <- dplyr::bind_rows(x_train, x_test)
+     
+     ## 2. Extract only mean and std for each measurement
+     meanstd <- dplyr::select(
+         x,
+         dplyr::contains("-mean()") | dplyr::contains("-std()")
+     )
+     
+     ## 3. Use descriptive activity names to name activities in the dataset
+     y_train <- load_y("train")
+     y_test <- load_y("test")
+     y <- dplyr::bind_rows(y_train, y_test)
+     
+     ## 4. Label dataset with descriptive variable names
+     idx <- NULL  # namespace idx to relieve lintr error
+     described <- dplyr::bind_cols(meanstd, dplyr::select(y, -idx))
+     described
+     
+     ## 5. Create dataset with means for each variable per activity and subject
+     activity <- subject <- NULL
+     grouped <- dplyr::group_by(described, activity, subject)
+     result <- dplyr::summarize_all(grouped, mean)
+     result
+ }
> 
> if (sys.nframe() == 0) {
+     result <- create_tidy_dataset()
+     readr::write_csv(result, "tidy.csv")
+ }

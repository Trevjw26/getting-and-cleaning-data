# getting-and-cleaning-data

Trevor Williams

This repository contains the source code and documentation to complete the
course project for the Coursera class, *Getting and Cleaning Data*.

## Expectations when sharing data

To facilitate efficient and timely analysis, one should pass along to a
statistician the following:

1. The raw data.
2. A tidy dataset.
3. A code book describing each variable and its values in the tidy dataset.
4. A recipe for going from 1 above to 2 and 3 above.

[Learn more here.](https://github.com/jtleek/datasharing)

## Repository contents

This repository does not contain the raw data or the tidy dataset. It
is a best practice to
[ignore files](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository#_ignoring)
that are automatically generated, rather than include them in version
control. The raw data is available from the same link referred to by
the [assignment](./ASSIGNMENT.md):

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The tidy dataset can accessed in R by running:

```R
source("run_analysis.R")
tidy_dataset <- create_tidy_dataset()
```

To write the tidy dataset directly to a local file `tidy.csv`, one can run:

```sh
Rscript run_analysis.R
```

The code book is available [here](./CODEBOOK.md).

The [run_analysis.R](./run_analysis.R) script is the recipe for both
obtaining the raw data from its source and cleaning that raw data to
produce the requested tidy dataset.

## The `run_analysis.R` script

This script defines three functions:

* `load_x()` - Loads the train or test dataset as a
  [tibble](https://tibble.tidyverse.org/)
* `load_y()` - Loads the train or test labels and subjects as a tibble.
* `create_tidy_dataset()` - Downloads and decompresses the raw data if not
  already downloaded, completes the assigned steps, and returns the tidy
  dataset as a tibble.

The `tidy.csv` file is only generated automatically when executed as a script.
No file is generated when the script is used via `source()`.

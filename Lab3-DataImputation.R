# *****************************************************************************
# Lab 3: Data Imputation ----
#
# Course Code: BBT4206
# Course Name: Business Intelligence II
# Semester Duration: 21st August 2023 to 28th November 2023
#
# Lecturer: Allan Omondi
# Contact: aomondi [at] strathmore.edu
#
# Note: The lecture contains both theory and practice. This file forms part of
#       the practice. It has required lab work submissions that are graded for
#       coursework marks.
#
# License: GNU GPL-3.0-or-later
# See LICENSE file for licensing information.
# *****************************************************************************

# Introduction ----
# Data imputation, also known as missing data imputation, is a technique used
# in data analysis and statistics to fill in missing values in a dataset.
# Missing data can occur due to various reasons, such as equipment malfunction,
# human error, or non-response in surveys.

# Imputing missing data is important because many statistical analysis methods
# and Machine Learning algorithms require complete datasets to produce accurate
# and reliable results. By filling in the missing values, data imputation helps
# to preserve the integrity and usefulness of the dataset.

## Data Imputation Methods ----

### 1. Mean/Median Imputation ----

# This method involves replacing missing values with the mean or median value
# of the available data for that variable. It is a simple and quick approach
# but does not consider any relationships between variables.

# Unlike the recorded values, mean-imputed values do not include natural
# variance. Therefore, they are less “scattered” and would technically minimize
# the standard error in a linear regression. We would perceive our estimates to
# be more accurate than they actually are in real-life.

### 2. Regression Imputation ----
# In this approach, missing values are estimated by regressing the variable
# with missing values on other variables that are known. The estimated values
# are then used to fill in the missing values.

### 3. Multiple Imputation ----
# Multiple imputation involves creating several plausible imputations for each
# missing value based on statistical models that capture the relationships
# between variables. This technique recognizes the uncertainty associated with
# imputing missing values.

### 4. Machine Learning-Based Imputation ----
# Machine learning algorithms can be used to predict missing values based on
# the patterns and relationships present in the available data. Techniques such
# as k-nearest neighbors (KNN) imputation or decision tree-based imputation can
# be employed.

### 5. Hot Deck Imputation ----
# This method involves finding similar cases (referred to as donors) that have
# complete data and using their values to impute missing values in other cases
# (referred to as recipients).

### 6. Multiple Imputation by Chained Equations (MICE) ----
# MICE is flexible and can handle different variable types at once (e.g.,
# continuous, binary, ordinal etc.). For each variable containing missing
# values, we can use the remaining information in the data to create a model
# that predicts what could have been recorded to fill in the blanks.
# To account for the statistical uncertainty in the imputations, the MICE
# procedure goes through several rounds and computes replacements for missing
# values in each round. As the name suggests, we thus fill in the missing
# values multiple times and create several complete datasets before we pool the
# results to arrive at more realistic results.

## Types of Missing Data ----
### 1. Missing Not At Random (MNAR) ----
# Locations of missing values in the dataset depend on the missing values
# themselves. For example, students submitting a course evaluation tend to
# report positive or neutral responses and skip questions that will result in a
# negative response. Such students may systematically leave the following
# question blank because they are uncomfortable giving a bad rating for their
# lecturer: “Classes started and ended on time”.

### 2. Missing At Random (MAR) ----
# Locations of missing values in the dataset depend on some other observed
# data. In the case of course evaluations, students who are not certain about a
# response may feel unable to give accurate responses on a numeric scale, for
# example, the question "I developed my oral and writing skills " may be
# difficult to measure on a scale of 1-5. Subsequently, if such questions are
# optional, they rarely get a response because it depends on another unobserved
# mechanism: in this case, the individual need for more precise
# self-assessments.

### 3. Missing Completely At Random (MCAR) ----
# In this case, the locations of missing values in the dataset are purely
# random and they do not depend on any other data.

# In all the above cases, removing the entire response  because one question
# has missing data may distort the results.

# If the data are MAR or MNAR, imputing missing values is advisable.

# *** Initialization: Install and use renv ----
# The renv package helps you create reproducible environments for your R
# projects. This is helpful when working in teams because it makes your R
# projects more isolated, portable and reproducible.

# Further reading:
#   Summary: https://rstudio.github.io/renv/
#   More detailed article: https://rstudio.github.io/renv/articles/renv.html

# Install renv:
if (!is.element("renv", installed.packages()[, 1])) {
  install.packages("renv", dependencies = TRUE)
}
require("renv")

# Use renv::init() to initialize renv in a new or existing project.

# The prompt received after executing renv::init() is as shown below:
# This project already has a lockfile. What would you like to do?

# 1: Restore the project from the lockfile.
# 2: Discard the lockfile and re-initialize the project.
# 3: Activate the project without snapshotting or installing any packages.
# 4: Abort project initialization.

# Select option 1 to restore the project from the lockfile
renv::init()

# This will set up a project library, containing all the packages you are
# currently using. The packages (and all the metadata needed to reinstall
# them) are recorded into a lockfile, renv.lock, and a .Rprofile ensures that
# the library is used every time you open that project.

# This can also be configured using the RStudio GUI when you click the project
# file, e.g., "BBT4206-R.Rproj" in the case of this project. Then
# navigate to the "Environments" tab and select "Use renv with this project".

# As you continue to work on your project, you can install and upgrade
# packages, using either:
# install.packages() and update.packages or
# renv::install() and renv::update()

# You can also clean up a project by removing unused packages using the
# following command: renv::clean()

# After you have confirmed that your code works as expected, use
# renv::snapshot() to record the packages and their
# sources in the lockfile.

# Later, if you need to share your code with someone else or run your code on
# a new machine, your collaborator (or you) can call renv::restore() to
# reinstall the specific package versions recorded in the lockfile.

# Execute the following code to reinstall the specific package versions
# recorded in the lockfile:
renv::restore()

# One of the packages required to use R in VS Code is the "languageserver"
# package. It can be installed manually as follows if you are not using the
# renv::restore() command.
if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")

# The US National Health and Nutrition Examination Study (NHANES) Package ----

# Documentation of NHANES:
#   https://cran.r-project.org/web/packages/NHANES/NHANES.pdf
if (!is.element("NHANES", installed.packages()[, 1])) {
  install.packages("NHANES", dependencies = TRUE)
}
require("NHANES")

if (!is.element("dplyr", installed.packages()[, 1])) {
  install.packages("dplyr", dependencies = TRUE)
}
require("dplyr")


# Make a selection
nhanes_long <- NHANES %>% select(Age, AgeDecade, Education, Poverty, Work,
                                 LittleInterest, Depressed, BMI, Pulse,
                                 BPSysAve, BPDiaAve, DaysPhysHlthBad,
                                 PhysActiveDays)
# Select 500 random indices
rand_ind <- sample(seq_len(nrow(nhanes_long)), 500)
nhanes <- nhanes_long[rand_ind, ]


# We also need the naniar package
# Documentation of naniar:
#   https://www.rdocumentation.org/packages/naniar/versions/1.0.0

if (!is.element("naniar", installed.packages()[, 1])) {
  install.packages("naniar", dependencies = TRUE)
}
require("naniar")

# Are there missing values in the dataset?
any_na(nhanes)
# How many?
n_miss(nhanes)
# What percentage?
prop_miss(nhanes)
# Which variables are affected?
nhanes %>% is.na() %>% colSums()

# Get number of missing values per variable (n and %)
miss_var_summary(nhanes)
miss_var_table(nhanes)
# Get number of missing values per participant (n and %)
miss_case_summary(nhanes)
miss_case_table(nhanes)

# Which variables contain the most missing values?
gg_miss_var(nhanes)

if (!is.element("ggplot2", installed.packages()[, 1])) {
  install.packages("ggplot2", dependencies = TRUE)
}
require("ggplot2")
# Where are missing values located?
vis_miss(nhanes) + theme(axis.text.x = element_text(angle = 80))

# Which combinations of variables occur to be missing together?
gg_miss_upset(nhanes)

# Create a heatmap of missingness broken down by age
is.factor(nhanes$AgeDecade)
gg_miss_fct(nhanes, fct = AgeDecade)

nhanes <- nhanes %>% mutate(MaP = BPDiaAve + 1/3*(BPSysAve - BPDiaAve))

if (!is.element("mice", installed.packages()[, 1])) {
  install.packages("mice", dependencies = TRUE)
}
require("mice")

# To arrive at good predictions for each of the target variable containing
# missing values, we save the variables that are at least somewhat correlated
# (r > 0.25) with it.
pred_mat <- quickpred(nhanes, mincor = 0.25)


# mice
nhanes_multimp <- mice(nhanes, m=10,meth='pmm',
                       seed = 5, predictorMatrix = pred_mat)


# with
lm_multimp <- with(nhanes_multimp, lm(MaP ~ BMI + PhysActiveDays))
# pool
lm_pooled <- pool(lm_multimp)
# analyse pooled results - does the confidence interval include both directions?
summary(lm_pooled, conf.int = TRUE, conf.level = 0.95)

stripplot(nhanes_multimp,
          MaP ~ BMI | .imp,
          pch = 20, cex = 1)

# create imputed data to work with
df <- mice::complete(nhanes_multimp, 1)

miss_var_summary(df)

if (!is.element("Amelia", installed.packages()[, 1])) {
  install.packages("Amelia", dependencies = TRUE)
}
require("Amelia")
Amelia::missmap(nhanes)

Amelia::missmap(Soybean, col = c("red", "grey"), legend = TRUE)

# Random Sample ====
# Create a random sample from the dataset
library(mlbench)
data(Soybean)
# Although optional, we can create a smaller sample of 400 observations from the original 683 observations in the Soybean dataset
random_index <- sample(1:nrow(Soybean),400)
Soybean.sample <- Soybean[random_index,]

# Show the missing values ====
### missmap() function ====
# This will show that roughly 10% of the data is missing
missmap(Soybean)
missmap(Soybean.sample)

### vis_miss() function ====
# This will also show roughly 10% of the data is missing in the whole dataset and also the percentage missing for each variable
vis_miss(Soybean.sample) + theme(axis.text.x = element_text(angle=80))

# If missing values are present (true/false) ====
# Load the required packages called "naniar" and "dplyr"
library(naniar)
library(dplyr)
# The `naniar::any_na()` function allows us to check if there are any missing values in the dataset.
any_na(Soybean.sample)

# Count number of missing values ====
# The `naniar::n_miss()` function allows us to count how many missing values we have in the dataset
n_miss(Soybean.sample)

# Calculate the proportion of missing values ====
# The `naniar::prop_miss()` function allows us to calculate the proportion of how many missing values we have in the dataset (multiply by 100 to get the percentage)
prop_miss(Soybean.sample)

# Count missing values per variable ====
# We can also count how many missing values we have per variable in the dataset
Soybean.sample %>% is.na() %>% colSums()

# The number of missing values we have per variable in the dataset can also be presented as a percentage for each variable
miss_var_summary(Soybean.sample)

# or (to print for all the 36 variables)
print(as_tibble(miss_var_summary(Soybean.sample)), n=36)

# Count missing values per observation ====
# The number of missing values we have per observation in the dataset can also be presented as a sample
miss_case_summary(Soybean.sample)

# Visualize percentage of missing values per variable ====
# The number of missing values we have per variable in the dataset can also be presented visually
gg_miss_var(Soybean.sample)

# The top 5 variables with the highest number of missing values are hail, sever, seed.tmt, lodging, and germ, each with 75% missing data.

# Visualize the Combination of variables that are missing together ====
# This shows the combination of variables that are missing together, for example germ, hail, sever, seed.tmt, and lodging are all missing together in many observation
gg_miss_upset(Soybean.sample)

# Visualize a heatmap of "missingness" broken down by the Target Vairable (Class) ====
is.factor(Soybean.sample$Class)
gg_miss_fct(Soybean.sample, fct = Class)

# Identify correlated variables ====
# Other variables that are correlated (r > 0.25) with the variable that has missing values are noted. These will be used to arrive at good predictions for the missing values. The results are stored in the prediction_matrix variable.

prediction_matrix <- quickpred(Soybean.sample, mincor = 0.25)

# Multivariate Imputation by Chained Equations (MICE) ====
library(mice)

# We then use the prediction matrix calculated in the previous step. We also set the number of times the imputation procedure should be run (8 times in this case) as well as the imputation method to use (Random Forest (rf) in this case).
Soybean.mice <- mice(Soybean.sample, m=8,meth='rf', predictorMatrix = prediction_matrix)

# A strip plot visualization allows us to see the progress of getting realistic data imputations from the first run to the last run of imputations
stripplot(Soybean.mice,
          Class ~ sever | .imp,
          pch = 20, cex = 1)

# Data Imputation ====
# Finally, perform the data imputation
Soybean.sample.imputed <-mice::complete(Soybean.mice,1)

# Confirmation of Data Imputation ====
## Show the missing values ====
### missmap() function ====
# This will show that 0% of the data is missing after the imputation
missmap(Soybean)
missmap(Soybean.sample)
missmap(Soybean.sample.imputed)

### vis_miss() function ====
# This will also show roughly 10% of the data is missing in the whole dataset and also the percentage missing for each variable
vis_miss(Soybean.sample) + theme(axis.text.x = element_text(angle=80))

# This will also show 0% of the data is missing in the whole dataset and also the percentage missing for each variable is now 0%
vis_miss(Soybean.sample.imputed) + theme(axis.text.x = element_text(angle=80))

### Visualize a heatmap of "missingness" broken down by the Target Vairable (Class) ====
gg_miss_fct(Soybean.sample.imputed, fct = Class)

### Visualize percentage of missing values per variable ====
gg_miss_var(Soybean.sample.imputed)

### *** Deinitialization: Create a snapshot of the R environment ----
# Lastly, as a follow-up to the initialization step, record the packages
# installed and their sources in the lockfile so that other team-members can
# use renv::restore() to re-install the same package version in their local
# machine during their initialization step.
renv::snapshot()

# References ----
## Bevans, R. (2023). Sample Crop Data Dataset for ANOVA (Version 1) [Dataset]. Scribbr. https://www.scribbr.com/wp-content/uploads//2020/03/crop.data_.anova_.zip # nolint ----

## Fisher, R. A. (1988). Iris [Dataset]. UCI Machine Learning Repository. https://archive.ics.uci.edu/dataset/53/iris # nolint ----

## National Institute of Diabetes and Digestive and Kidney Diseases. (1999). Pima Indians Diabetes Dataset [Dataset]. UCI Machine Learning Repository. https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database # nolint ----

## StatLib CMU. (1997). Boston Housing [Dataset]. StatLib Carnegie Mellon University. http://lib.stat.cmu.edu/datasets/boston_corrected.txt # nolint ----

# **Required Lab Work Submission** ----

## Part A ----
# Create a new file called
# "Lab4-Submission-ExposingTheStructureOfDataUsingDataTransforms.R".
# Provide all the code you have used to perform data transformation on the
# "BI1 Class Performance" dataset provided in class. Perform ALL the data
# transformations that have been used in the
# "Lab4-ExposingTheStructureOfDataUsingDataTransforms.R" file.

## Part B ----
# Upload *the link* to your
# "Lab4-Submission-ExposingTheStructureOfDataUsingDataTransforms.R" hosted
# on Github (do not upload the .R file itself) through the submission link
# provided on eLearning.

## Part C ----
# Create a markdown file called
# "Lab4-Submission-ExposingTheStructureOfDataUsingDataTransforms.Rmd"
# and place it inside the folder called "markdown".

## Part D ----
# Knit the R markdown file using knitR in R Studio.
# Upload *the link* to
# "Lab4-Submission-ExposingTheStructureOfDataUsingDataTransforms.md"
# (not .Rmd) markdown file hosted on Github (do not upload the .Rmd or .md
# markdown files) through the submission link
# provided on eLearning.
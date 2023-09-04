# *****************************************************************************
# Lab 4: Exposing the Structure of Data using Data Transforms ----
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
# Data transforms can improve the accuracy of your final model when applied as
# part of the pre-processing stage. It is standard practice to apply multiple
# transforms with a suite of different machine learning algorithms. Data
# transforms can be grouped into the following 3 categories:
#   (i)	Basic data transforms: scaling, centering, standardization, and
#       normalization
#   (ii)	Power transforms: Box-Cox and Yeo-Johnson
#   (iii)	Linear algebra transforms: Principal Component Analysis (PCA) and
#         Independent Component Analysis (ICA)

# The first step is to design a model of the transform using the training data.
# This results in a model of the transform that can be applied to multiple
# datasets. The preparation of the model of the transform is done using the
# preProcess() function. The model of the transform can then be applied to a
# dataset in either of the following two ways:
#   (i)	Standalone: The model of the transform is passed to the predict()
#       function
#   (ii)	Training: The model of the transform is passed to the train()
#         function via the preProcess argument. This is done during the model
#         evaluation stage.
# Note that the preProcess() function ignores non-numeric attributes.

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

## STEP 1. Load the Datasets ----

### The Boston Housing Dataset ----
# Execute the following to load the “BostonHousing” dataset which is offered
# in the "mlbench" package:
if (!is.element("mlbench", installed.packages()[, 1])) {
  install.packages("mlbench", dependencies = TRUE)
}
require("mlbench")
data("BostonHousing")

### Crop Dataset ----
# Execute the following to load the downloaded Crop dataset:
if (!is.element("readr", installed.packages()[, 1])) {
  install.packages("readr", dependencies = TRUE)
}
require("readr")
crop_dataset <- read_csv("data/crop.data.csv",
  col_types = cols(
    density = col_factor(levels = c("1", "2")),
    block = col_factor(levels = c("1", "2", "3", "4")),
    fertilizer = col_factor(levels = c("1", "2", "3"))
  )
)

### Iris Dataset ----
# Execute the following to load the downloaded Iris dataset:
iris_dataset <- read.csv("data/iris.data", header = FALSE,
                         stringsAsFactors = TRUE)
# This time, we name the attributes of the Iris Dataset as follows:
names(iris_dataset) <- c("sepal length in cm", "sepal width in cm",
                         "petal length in cm", "petal width in cm", "class")

### The Pima Indians Diabetes Dataset ----
# Execute the following to load the "Pima Indians Diabetes" dataset from the
# mlbench package:
data("PimaIndiansDiabetes")

# Scale Data Transform ----

## STEP 2. Apply a Scale Data Transform ----
# The scale data transform is useful for scaling data that has a Gaussian
# distribution. The scale data transform works by calculating the standard
# deviation of an attribute and then divides each value by the standard
# deviation.

# The "preProcess()" function is in the caret package
if (!is.element("caret", installed.packages()[, 1])) {
  install.packages("caret", dependencies = TRUE)
}
require("caret")

### The Scale Basic Transform on the Boston Housing Dataset ----
summary(BostonHousing)
model_of_the_transform <- preProcess(BostonHousing, method = c("scale"))
print(model_of_the_transform)
boston_housing_scale_transform <- predict(model_of_the_transform,
                                          BostonHousing)
summary(boston_housing_scale_transform)

### The Scale Basic Transform on the Crop Dataset ----
summary(crop_dataset)
model_of_the_transform <- preProcess(crop_dataset, method = c("scale"))
print(model_of_the_transform)
crop_data_scale_transform <- predict(model_of_the_transform, crop_dataset)
summary(crop_data_scale_transform)

# Center Data Transform ----

## STEP 3. Apply a Centre Data Transform ----
# The centre data transform calculates the mean of an attribute and subtracts
# it from each value.

### The Centre Basic Transform on the Boston Housing Dataset ----
summary(BostonHousing)
model_of_the_transform <- preProcess(BostonHousing, method = c("center"))
print(model_of_the_transform)
boston_housing_center_transform <- predict(model_of_the_transform, # nolint
                                           BostonHousing)
summary(boston_housing_center_transform)

### The Centre Basic Transform on the Crop Dataset ----
summary(crop_dataset)
model_of_the_transform <- preProcess(crop_dataset, method = c("center"))
print(model_of_the_transform)
crop_data_center_transform <- predict(model_of_the_transform, crop_dataset)
summary(crop_data_center_transform)

### The Centre Basic Transform on the Iris Dataset ----
summary(iris_dataset)
model_of_the_transform <- preProcess(iris_dataset, method = c("center"))
print(model_of_the_transform)
iris_dataset_center_transform <- predict(model_of_the_transform, iris_dataset)
summary(iris_dataset_center_transform)

### The Centre Basic Transform on the Pima Indians Diabetes Dataset ----
summary(PimaIndiansDiabetes)
model_of_the_transform <- preProcess(PimaIndiansDiabetes, method = c("center"))
print(model_of_the_transform)
pima_indians_diabetes_center_transform <- predict(model_of_the_transform, # nolint
                                                  PimaIndiansDiabetes)
summary(pima_indians_diabetes_center_transform)

# Standardize Data Transform ----
## STEP 4. Apply a Standardize Data Transform ----
# The standardize data transform ensures that each numeric attribute has a mean
# value of 0 and a standard deviation of 1. This is done by combining the scale
# data transform and the centre data transform.

### The Standardize Basic Transform on the Boston Housing Dataset ----
summary(BostonHousing)
model_of_the_transform <- preProcess(BostonHousing,
                                     method = c("scale", "center"))
print(model_of_the_transform)
boston_housing_standardize_transform <- predict(model_of_the_transform, # nolint
                                                BostonHousing)
summary(boston_housing_standardize_transform)

### The Standardize Basic Transform on the Crop Dataset ----
summary(crop_dataset)
model_of_the_transform <- preProcess(crop_dataset,
                                     method = c("scale", "center"))
print(model_of_the_transform)
crop_data_standardize_transform <- predict(model_of_the_transform, crop_dataset) # nolint
summary(crop_data_standardize_transform)

### The Standardize Basic Transform on the Iris Dataset ----
summary(iris_dataset)
model_of_the_transform <- preProcess(iris_dataset,
                                     method = c("scale", "center"))
print(model_of_the_transform)
iris_dataset_standardize_transform <- predict(model_of_the_transform, # nolint
                                              iris_dataset)
summary(iris_dataset_standardize_transform)

### The Standardize Basic Transform on the Pima Indians Diabetes Dataset ----
summary(PimaIndiansDiabetes)
model_of_the_transform <- preProcess(PimaIndiansDiabetes,
                                     method = c("scale", "center"))
print(model_of_the_transform)
pima_indians_diabetes_standardize_transform <- predict(model_of_the_transform, # nolint
                                                       PimaIndiansDiabetes)
summary(pima_indians_diabetes_standardize_transform)

# Normalize Data Transform ----

## STEP 5. Apply a Normalize Data Transform ----
# Normalizing a dataset implies scaling the numerical data so that the values
# are between [0, 1] (inclusive).

### The Normalize Basic Transform on the Boston Housing Dataset ----
summary(BostonHousing)
model_of_the_transform <- preProcess(BostonHousing, method = c("range"))
print(model_of_the_transform)
boston_housing_normalize_transform <- predict(model_of_the_transform, # nolint
                                              BostonHousing)
summary(boston_housing_normalize_transform)

### The Normalize Basic Transform on the Crop Dataset ----
summary(crop_dataset)
model_of_the_transform <- preProcess(crop_dataset, method = c("range"))
print(model_of_the_transform)
crop_data_normalize_transform <- predict(model_of_the_transform, crop_dataset)
summary(crop_data_normalize_transform)

### The Normalize Basic Transform on the Iris Dataset ----
summary(iris_dataset)
model_of_the_transform <- preProcess(iris_dataset, method = c("range"))
print(model_of_the_transform)
iris_dataset_normalize_transform <- predict(model_of_the_transform, # nolint
                                            iris_dataset)
summary(iris_dataset_normalize_transform)

### The Normalize Basic Transform on the Pima Indians Diabetes Dataset ----
summary(PimaIndiansDiabetes)
model_of_the_transform <- preProcess(PimaIndiansDiabetes, method = c("range"))
print(model_of_the_transform)
pima_indians_diabetes_normalize_transform <- predict(model_of_the_transform, # nolint
                                                     PimaIndiansDiabetes)
summary(pima_indians_diabetes_normalize_transform)


# Box-Cox Power Transform ----

## STEP 6. Apply a Box-Cox Power Transform ----
# The skewness informs you of the asymmetry of the distribution of results.
# Similar to kurtosis, there are several ways of computing the skewness. Using
# “type = 2” (discussed in a previous Lab) can be interpreted as:
#   1.	Skewness between -0.4 and 0.4 (inclusive) implies that there is no
#       skew in the distribution of results; the distribution of results is
#       symmetrical; it is a normal distribution.
#   2.	Skewness above 0.4 implies a positive skew; a right-skewed distribution.
#   3.	Skewness below -0.4 implies a negative skew; a left-skewed distribution.

# Skewness occurs when an attribute has a Gaussian-like distribution but it is
# shifted. The Box-Cox transform reduces the skewness by shifting the
# distribution of an attribute and making the attribute have a more
# Gaussian-like distribution.

if (!is.element("e1071", installed.packages()[, 1])) {
  install.packages("e1071", dependencies = TRUE)
}
require("e1071")

### Box-Cox Power Transform on the Boston Housing Dataset ----
summary(BostonHousing)

#Calculate the skewness before the Box-Cox transform
sapply(BostonHousing[, -4],  skewness, type = 2)

#Plot a histogram to view the skewness before the Box-Cox transform
hist(BostonHousing[, 1], main = names(BostonHousing)[1])
hist(BostonHousing[, 2], main = names(BostonHousing)[2])
hist(BostonHousing[, 3], main = names(BostonHousing)[3])
hist(BostonHousing[, 5], main = names(BostonHousing)[5])
hist(BostonHousing[, 6], main = names(BostonHousing)[6])
hist(BostonHousing[, 7], main = names(BostonHousing)[7])
hist(BostonHousing[, 8], main = names(BostonHousing)[8])
hist(BostonHousing[, 9], main = names(BostonHousing)[9])
hist(BostonHousing[, 10], main = names(BostonHousing)[10])
hist(BostonHousing[, 11], main = names(BostonHousing)[11])
hist(BostonHousing[, 12], main = names(BostonHousing)[12])
hist(BostonHousing[, 13], main = names(BostonHousing)[13])
hist(BostonHousing[, 14], main = names(BostonHousing)[14])

model_of_the_transform <- preProcess(BostonHousing, method = c("BoxCox"))
print(model_of_the_transform)
boston_housing_box_cox_transform <- predict(model_of_the_transform, # nolint
                                            BostonHousing)
summary(boston_housing_box_cox_transform)

#Calculate the skewness after the Box-Cox transform
sapply(boston_housing_box_cox_transform[, -4],  skewness, type = 2)

#Plot a histogram to view the skewness after the Box-Cox transform
hist(boston_housing_box_cox_transform[, 1],
     main = names(boston_housing_box_cox_transform)[1])
hist(boston_housing_box_cox_transform[, 2],
     main = names(boston_housing_box_cox_transform)[2])
hist(boston_housing_box_cox_transform[, 3],
     main = names(boston_housing_box_cox_transform)[3])
hist(boston_housing_box_cox_transform[, 5],
     main = names(boston_housing_box_cox_transform)[5])
hist(boston_housing_box_cox_transform[, 6],
     main = names(boston_housing_box_cox_transform)[6])
hist(boston_housing_box_cox_transform[, 7],
     main = names(boston_housing_box_cox_transform)[7])
hist(boston_housing_box_cox_transform[, 8],
     main = names(boston_housing_box_cox_transform)[8])
hist(boston_housing_box_cox_transform[, 9],
     main = names(boston_housing_box_cox_transform)[9])
hist(boston_housing_box_cox_transform[, 10],
     main = names(boston_housing_box_cox_transform)[10])
hist(boston_housing_box_cox_transform[, 11],
     main = names(boston_housing_box_cox_transform)[11])
hist(boston_housing_box_cox_transform[, 12],
     main = names(boston_housing_box_cox_transform)[12])
hist(boston_housing_box_cox_transform[, 13],
     main = names(boston_housing_box_cox_transform)[13])
hist(boston_housing_box_cox_transform[, 14],
     main = names(boston_housing_box_cox_transform)[14])

### Box-Cox Power Transform on the Crop Dataset ----
summary(crop_dataset)

# Calculate the skewness before the Box-Cox transform
sapply(crop_data_standardize_transform[, 4],  skewness, type = 2)
sapply(crop_data_standardize_transform[, 4], sd)

model_of_the_transform <- preProcess(crop_data_standardize_transform,
                                     method = c("BoxCox"))
print(model_of_the_transform)
crop_data_box_cox_transform <- predict(model_of_the_transform,
                                       crop_data_standardize_transform)
summary(crop_data_box_cox_transform)

# Calculate the skewness after the Box-Cox transform
sapply(crop_data_box_cox_transform[, 4],  skewness, type = 2)
sapply(crop_data_box_cox_transform[, 4], sd)

# Notice that none of the attributes qualify to be transformed using the Box
# Cox data transform.

### Box-Cox Power Transform on the Iris Dataset ----

summary(iris_dataset)

# Calculate the skewness before the Box-Cox transform
sapply(iris_dataset[, 1:4],  skewness, type = 2)

# Plot a histogram to view the skewness before the Box-Cox transform
par(mfrow = c(1, 4))
for (i in 1:4) {
  hist(iris_dataset[, i], main = names(iris_dataset)[i])
}

model_of_the_transform <- preProcess(iris_dataset, method = c("BoxCox"))
print(model_of_the_transform)

iris_dataset_box_cox_transform <- predict(model_of_the_transform,
                                          iris_dataset)
summary(iris_dataset_box_cox_transform)

# Calculate the skewness after the Box-Cox transform
sapply(iris_dataset_box_cox_transform[, 1:4],  skewness, type = 2)

# Plot a histogram to view the skewness after the Box-Cox transform
par(mfrow = c(1, 4))
for (i in 1:4) {
  hist(iris_dataset_box_cox_transform[, i],
       main = names(iris_dataset_box_cox_transform)[i])
}

model_of_the_transform <- preProcess(iris_dataset, method = c("BoxCox"))
print(model_of_the_transform)
iris_dataset_box_cox_transform <- predict(model_of_the_transform,
                                          iris_dataset)
summary(iris_dataset_box_cox_transform)

# Calculate the skewness after the Box-Cox transform
sapply(iris_dataset_box_cox_transform[, 1:4],  skewness, type = 2)

# Plot a histogram to view the skewness after the Box-Cox transform
par(mfrow = c(1, 4))
for (i in 1:4) {
  hist(iris_dataset_box_cox_transform[, i],
       main = names(iris_dataset_box_cox_transform)[i])
}

### Box-Cox Power Transform on the Pima Indians Diabetes Dataset ----
summary(PimaIndiansDiabetes)

# Calculate the skewness before the Box-Cox transform
sapply(PimaIndiansDiabetes[, 1:8],  skewness, type = 2)

# Plot a histogram to view the skewness before the Box-Cox transform
par(mfrow = c(1, 8))
for (i in 1:8) {
  hist(PimaIndiansDiabetes[, i], main = names(PimaIndiansDiabetes)[i])
}

model_of_the_transform <- preProcess(PimaIndiansDiabetes, method = c("BoxCox"))
print(model_of_the_transform)
pima_indians_diabetes_box_cox_transform <- predict(model_of_the_transform, # nolint
                                                   PimaIndiansDiabetes)
summary(pima_indians_diabetes_box_cox_transform)

# Calculate the skewness after the Box-Cox transform
sapply(pima_indians_diabetes_box_cox_transform[, 1:8],  skewness, type = 2)

# Plot a histogram to view the skewness after the Box-Cox transform
par(mfrow = c(1, 8))
for (i in 1:8) {
  hist(pima_indians_diabetes_box_cox_transform[, i],
       main = names(pima_indians_diabetes_box_cox_transform)[i])
}


# Yeo-Johnson Power Transform ====

## STEP 7. Apply a Yeo-Johnson Power Transform ====
# Similar to the Box-Cox transform, the Yeo-Johnson transform reduces the
# skewness by shifting the distribution of an attribute and making the
# attribute have a more Gaussian-like distribution. The difference is that the
# Yeo-Johnson transform can handle zero and negative values, unlike the Box-Cox
# transform.

### Yeo-Johnson Power Transform on the Boston Housing Dataset ----
summary(BostonHousing)

# Calculate the skewness before the Yeo-Johnson transform
sapply(BostonHousing[, -4],  skewness, type = 2)

# Plot a histogram to view the skewness before the Box-Cox transform
hist(BostonHousing[, 1], main = names(BostonHousing)[1])
hist(BostonHousing[, 2], main = names(BostonHousing)[2])
hist(BostonHousing[, 3], main = names(BostonHousing)[3])
hist(BostonHousing[, 5], main = names(BostonHousing)[5])
hist(BostonHousing[, 6], main = names(BostonHousing)[6])
hist(BostonHousing[, 7], main = names(BostonHousing)[7])
hist(BostonHousing[, 8], main = names(BostonHousing)[8])
hist(BostonHousing[, 9], main = names(BostonHousing)[9])
hist(BostonHousing[, 10], main = names(BostonHousing)[10])
hist(BostonHousing[, 11], main = names(BostonHousing)[11])
hist(BostonHousing[, 12], main = names(BostonHousing)[12])
hist(BostonHousing[, 13], main = names(BostonHousing)[13])
hist(BostonHousing[, 14], main = names(BostonHousing)[14])

model_of_the_transform <- preProcess(BostonHousing, method = c("YeoJohnson"))
print(model_of_the_transform)
boston_housing_yeo_johnson_transform <- predict(model_of_the_transform, # nolint
                                                BostonHousing)
summary(boston_housing_yeo_johnson_transform)

# Calculate the skewness after the Yeo-Johnson transform
sapply(boston_housing_yeo_johnson_transform[, -4],  skewness, type = 2)

# Plot a histogram to view the skewness after the Box-Cox transform
hist(boston_housing_yeo_johnson_transform[, 1],
     main = names(boston_housing_yeo_johnson_transform)[1])
hist(boston_housing_yeo_johnson_transform[, 2],
     main = names(boston_housing_yeo_johnson_transform)[2])
hist(boston_housing_yeo_johnson_transform[, 3],
     main = names(boston_housing_yeo_johnson_transform)[3])
hist(boston_housing_yeo_johnson_transform[, 5],
     main = names(boston_housing_yeo_johnson_transform)[5])
hist(boston_housing_yeo_johnson_transform[, 6],
     main = names(boston_housing_yeo_johnson_transform)[6])
hist(boston_housing_yeo_johnson_transform[, 7],
     main = names(boston_housing_yeo_johnson_transform)[7])
hist(boston_housing_yeo_johnson_transform[, 8],
     main = names(boston_housing_yeo_johnson_transform)[8])
hist(boston_housing_yeo_johnson_transform[, 9],
     main = names(boston_housing_yeo_johnson_transform)[9])
hist(boston_housing_yeo_johnson_transform[, 10],
     main = names(boston_housing_yeo_johnson_transform)[10])
hist(boston_housing_yeo_johnson_transform[, 11],
     main = names(boston_housing_yeo_johnson_transform)[11])
hist(boston_housing_yeo_johnson_transform[, 12],
     main = names(boston_housing_yeo_johnson_transform)[12])
hist(boston_housing_yeo_johnson_transform[, 13],
     main = names(boston_housing_yeo_johnson_transform)[13])
hist(boston_housing_yeo_johnson_transform[, 14],
     main = names(boston_housing_yeo_johnson_transform)[14])

### Yeo-Johnson Power Transform on the Crop Dataset ----
summary(crop_data_standardize_transform)

# Calculate the skewness before the Yeo-Johnson transform
sapply(crop_data_standardize_transform[, 4],  skewness, type = 2)
sapply(crop_data_standardize_transform[, 4], sd)

model_of_the_transform <- preProcess(crop_data_standardize_transform,
                                     method = c("YeoJohnson"))
print(model_of_the_transform)
crop_data_yeo_johnson_transform <- predict(model_of_the_transform, # nolint
                                           crop_data_standardize_transform)
summary(crop_data_yeo_johnson_transform)

# Calculate the skewness after the Yeo-Johnson transform
sapply(crop_data_yeo_johnson_transform[, 4],  skewness, type = 2)
sapply(crop_data_yeo_johnson_transform[, 4], sd)

# Notice that unlike the Box-Cox data transform, the Yeo-Johnson data
# transform considers 1 of the attributes (yield) as qualified to be
# transformed using the Yeo-Johnson transform.

### Yeo-Johnson Power Transform on the Iris Dataset ----
summary(iris_dataset)

# Calculate the skewness before the Yeo-Johnson transform
sapply(iris_dataset[, 1:4],  skewness, type = 2)

# Plot a histogram to view the skewness before the Yeo-Johnson transform
par(mfrow = c(1, 4))
for (i in 1:4) {
  hist(iris_dataset[, i], main = names(iris_dataset)[i])
}

model_of_the_transform <- preProcess(iris_dataset, method = c("YeoJohnson"))
print(model_of_the_transform)
iris_dataset_yeo_johnson_transform <- predict(model_of_the_transform, iris_dataset) # nolint
summary(iris_dataset_yeo_johnson_transform)

# Calculate the skewness after the Yeo-Johnson transform
sapply(iris_dataset_yeo_johnson_transform[, 1:4],  skewness, type = 2)

# Plot a histogram to view the skewness after the Yeo-Johnson transform
par(mfrow = c(1, 4))
for (i in 1:4) {
  hist(iris_dataset_yeo_johnson_transform[, i],
       main = names(iris_dataset_yeo_johnson_transform)[i])
}

### Yeo-Johnson Power Transform on the Pima Indians Diabetes Dataset ----
summary(PimaIndiansDiabetes)

# Calculate the skewness before the Yeo-Johnson transform
sapply(PimaIndiansDiabetes[, 1:8],  skewness, type = 2)

# Plot a histogram to view the skewness before the Yeo-Johnson transform
par(mfrow = c(1, 8))
for (i in 1:8) {
  hist(PimaIndiansDiabetes[, i], main = names(PimaIndiansDiabetes)[i])
}

model_of_the_transform <- preProcess(PimaIndiansDiabetes,
                                     method = c("YeoJohnson"))
print(model_of_the_transform)
pima_indians_diabetes_yeo_johnson_transform <- predict(model_of_the_transform, # nolint
                                                       PimaIndiansDiabetes)
summary(pima_indians_diabetes_yeo_johnson_transform)

# Calculate the skewness after the Yeo-Johnson transform
sapply(pima_indians_diabetes_yeo_johnson_transform[, 1:8],  skewness, type = 2)

# Plot a histogram to view the skewness after the Yeo-Johnson transform
par(mfrow = c(1, 8))
for (i in 1:8) {
  hist(pima_indians_diabetes_yeo_johnson_transform[, i],
       main = names(pima_indians_diabetes_yeo_johnson_transform)[i])
}

# Principal Component Analysis (PCA) Linear Algebra Transform ----

## Dimensionality Reduction versus Feature Selection ----
# PCA and ICA are primarily a dimensionality reduction technique used to
# transform high-dimensional data into a lower-dimensional space while
# retaining as much variance as possible. However, it can indirectly assist in
# feature selection by identifying the most important features or components.

# Feature selection and dimensionality reduction are both techniques used to
# reduce the number of features (variables) in a dataset, but they serve
# different purposes and operate in slightly different ways:

# 1. **Feature Selection**:
#    - **Purpose**: The primary goal of feature selection is to choose a subset
#                   of the most relevant and informative features from the
#                   original feature set while discarding irrelevant or
#                   redundant features.
#    - **Mechanism**: Feature selection methods evaluate each feature
#                   individually or in combination with others based on some
#                   criteria (e.g., correlation, mutual information,
#                   statistical tests) and select the most important features.
#    - **Result**: The result is a reduced feature set containing a subset of
#                   the original features. These selected features are typically
#                   unchanged or minimally transformed.
#    - **Interpretability**: Feature selection retains the original features,
#                   making it easier to interpret the relationship between
#                   features and the target variable.

# 2. **Dimensionality Reduction**:
#    - **Purpose**: The primary goal of dimensionality reduction is to
#                   transform the original feature space into a
#                   lower-dimensional space while retaining as much information
#                   (variance) as possible. It is often used to address issues
#                   like multicollinearity, overfitting, and computational
#                   complexity.
#    - **Mechanism**: Dimensionality reduction methods *create new features*
#                   (principal components or latent variables) that are linear
#                   combinations of the original features. These new features
#                   are ordered by the amount of variance they capture.
#    - **Result**: The result is a reduced-dimensional dataset with fewer
#                   features (principal components) than the original dataset.
#                   These new features are typically linearly uncorrelated and
#                   orthogonal to each other.
#    - **Interpretability**: The principal components created by dimensionality
#                   reduction may not have direct interpretability because they
#                   are linear combinations of original features. However, they
#                   capture patterns of variation in the data.

# In summary, feature selection involves choosing a subset of the original
# features to keep while discarding others, with the aim of retaining the
# interpretability of the selected features.

# Dimensionality reduction, on the other hand, creates new features (principal
# components) that summarize the information in the original features, often at
# the cost of interpretability.

# The choice between these techniques depends on your specific goals, the
# nature of your data, and the trade-offs between interpretability and data
# reduction.

# The technique used below is dimensionality reduction, followed by an
# identification of the features that are most represented in the principal
# or independent components.

## STEP 8.a. PCA Linear Algebra Transform for Dimensionality Reduction ----
# Principal Component Analysis (PCA) is a statistical approach that can be used
# to analyse high-dimensional data and capture the most important information
# (principal components) from it. This is done by transforming the original
# data into a lower-dimensional space while collating highly correlated
# variables together.

# PCA is applicable when the data is quantitative.
# If the data is qualitative, then Multiple Correspondence Analysis (MCA) or
# Correspondence Analysis (CA) can be used instead.

# If the data has both quantitative and qualitative values, then Multiple
# Factor Analysis (MFA) or Factor Analysis of Mixed Data (FAMD) can be used
# instead.

# Tutorial: https://www.datacamp.com/tutorial/pca-analysis-r

### PCA for Dimensionality Reduction on the Boston Housing Dataset ----
# The initial 13 numeric variables in the Boston Housing dataset are reduced to
# 10 variables which are in the form of principal components (not the initial
# features).
summary(BostonHousing)

model_of_the_transform <- preProcess(BostonHousing, method =
                                       c("scale", "center", "pca"))

print(model_of_the_transform)
boston_housing_pca_dr <- predict(model_of_the_transform, BostonHousing)

summary(boston_housing_pca_dr)

### PCA for Dimensionality Reduction on the Crop Dataset ----
# Notice that PCA is not applied to the “Crop Data” dataset because it requires
# multiple numeric independent variables. The dataset has 3 categorical
# independent variables and only 1 numeric independent variable.

### PCA for Dimensionality Reduction on the Iris Dataset ----
# The initial 4 numeric variables are reduced to 2 principal components
summary(iris_dataset)

model_of_the_transform <- preProcess(iris_dataset,
                                     method = c("scale", "center", "pca"))
print(model_of_the_transform)
iris_dataset_pca_dr <- predict(model_of_the_transform, iris_dataset)

summary(iris_dataset_pca_dr)
dim(iris_dataset_pca_dr)

### PCA for Dimensionality Reduction on the Pima Indians Diabetes Dataset ----
# The initial 8 numeric variables are "reduced" to 8 principal components
summary(PimaIndiansDiabetes)

model_of_the_transform <- preProcess(PimaIndiansDiabetes,
                                     method = c("scale", "center", "pca"))
print(model_of_the_transform)
pima_indians_diabetes_pca_transform <- predict(model_of_the_transform, # nolint
                                               PimaIndiansDiabetes)
summary(pima_indians_diabetes_pca_transform)

## STEP 8.b. PCA Linear Algebra Transform for Feature Extraction ----

# We use the `princomp()` function is used to perform PCA on a correlation
# matrix.

### PCA for Feature Extraction on the Boston Housing Dataset ----
boston_housing_pca_fe <- princomp(cor(BostonHousing[, -4]))
summary(boston_housing_pca_fe)

#### Scree Plot ----
# The Scree Plot shows that the 1st 2 principal components can cumulatively
# explain 92.8% of the variance, i.e., 87.7% + 5.1% = 92.8%.
if (!is.element("factoextra", installed.packages()[, 1])) {
  install.packages("factoextra", dependencies = TRUE)
}
require("factoextra")

factoextra::fviz_eig(boston_housing_pca_fe, addlabels = TRUE)

#### Loading Values ----
# Remember: Principal components are new features created in the process of
#           dimensionality reduction. We would like to know the extent to which
#           each feature is represented in the 1st 2 principal components. We
#           can use "loading values" to determine the extent of representation.

# The loading values for each variable in the 1st 2 principal components are
# shown below:
boston_housing_pca_fe$loadings[, 1:2]

# This is easier to understand using a visualization that shows the extent to
# which each variable is represented in a given component.

# In this case, it shows the extent to which each variable is represented in
# the first 2 components:

if (!is.element("FactoMineR", installed.packages()[, 1])) {
  install.packages("FactoMineR", dependencies = TRUE)
}
require("FactoMineR")

# Points to note when interpreting the visualization:
# The Cos2 value is the square cosine. It corresponds to the quality of
# representation.
#    (i) A low value means that the variable is not perfectly represented by
#         that component.
#    (ii) A high value, on the other hand, means a good representation of the
#         variable on that component.

factoextra::fviz_cos2(boston_housing_pca_fe, choice = "var", axes = 1:4)

# The 8 most represented variables in the first 2 components (which we said
# represent 92.8% of the variation) are, in descending order: indus, nox,
# lstat, dis, tax, age, medv, rad

#### Biplot and Cos2 Combined Plot ----
# This can be confirmed using the following visualization.

# Points to note when interpreting the visualization:
#    (i) All the variables that are grouped together are positively correlated.
#    (ii) The longer the arrow, the better represented the variable is.
#    (iii) Variables that are negatively correlated are displayed in the
#          opposite side of the origin.

factoextra::fviz_pca_var(boston_housing_pca, col.var = "cos2",
                         gradient.cols = c("red", "orange", "green"),
                         repel = TRUE)

### PCA for Feature Extraction on the Pima Indians Diabetes Dataset ----

pima_indians_diabetes_fe <- princomp(cor(PimaIndiansDiabetes[, 1:8]))
summary(pima_indians_diabetes_fe)

#### Scree Plot ----
# The Scree Plot shows that the 1st 4 components can cumulatively explain
# 87.4% of the variance.
factoextra::fviz_eig(pima_indians_diabetes_fe,
                     addlabels = TRUE)

#### Loading Values ----
# The loading values for each variable in the 1st 4 principal components are
# shown below
pima_indians_diabetes_fe$loadings[, 1:4]

# This is easier to understand using a visualization that shows the extent to
# which each variable is represented in a given component.

# In this case, it shows the extent to which each variable is represented in
# the first 4 components:
factoextra::fviz_cos2(pima_indians_diabetes_fe,
                      choice = "var", axes = 1:4)

# The 6 most represented variables in the first 4 components are, in descending
# order: pregnant, age, triceps, pedigree, insulin, and glucose

#### Biplot and Cos2 Combined Plot ----
# This can be confirmed using the following visualization.

fviz_pca_var(pima_indians_diabetes_fe, col.var = "cos2",
             gradient.cols = c("red", "black", "green"),
             repel = TRUE)


# Independent Component Analysis (ICA) Linear Algebra Transform ----
## STEP 9. ICA Linear Algebra Transform for Dimensionality Reduction ----

# Independent Component Analysis (ICA) transforms the data to return only the
# independent components. The n.comp argument is required to specify the
# desired number of independent components. This also results in a list of
# attributes that are uncorrelated.

if (!is.element("fastICA", installed.packages()[, 1])) {
  install.packages("fastICA", dependencies = TRUE)
}
require("fastICA")

### ICA for Dimensionality Reduction on the Boston Housing Dataset ----
summary(BostonHousing)

model_of_the_transform <- preProcess(BostonHousing,
                                     method = c("scale", "center", "ica"),
                                     n.comp = 8)
print(model_of_the_transform)
boston_housing_ica_dr <- predict(model_of_the_transform, BostonHousing)

summary(boston_housing_ica_dr)

### ICA for Dimensionality Reduction on the Crop Dataset ----
# Notice that ICA is not applied to the “Crop Data” dataset because it requires
# multiple numeric independent variables. The dataset has 3 categorical
# independent variables and only 1 numeric independent variable.

### ICA for Dimensionality Reduction on the Iris Dataset ----
summary(iris_dataset)
model_of_the_transform <- preProcess(iris_dataset,
                                     method = c("scale", "center", "ica"),
                                     n.comp = 3)
print(model_of_the_transform)
iris_dataset_ica_dr <- predict(model_of_the_transform, iris_dataset)

summary(iris_dataset_ica_dr)

### ICA for Dimensionality Reduction on the Pima Indians Diabetes Dataset ----
summary(PimaIndiansDiabetes)

model_of_the_transform <- preProcess(PimaIndiansDiabetes,
                                     method = c("scale", "center", "ica"),
                                     n.comp = 4)
print(model_of_the_transform)
pima_indians_diabetes_ica <- predict(model_of_the_transform,
                                     PimaIndiansDiabetes)

summary(pima_indians_diabetes_ica)


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
# Load cluster inputs (clinical features)
data <- read.csv("Lamers_df.csv", header = FALSE)

# Select features (exclude first column) and the first column
data_selected <- data[, -1]
eid <- data[, 1]

# Verify column names
colnames(data_selected) <- paste0("V", 1:ncol(data_selected))

# Load the poLCA package
library(poLCA)

# Define the formula for poLCA
f <- as.formula(paste("cbind(", paste0("V", 1:ncol(data_selected), collapse = ", "), ") ~ 1"))

# Initialize variables for models and metrics
lc <- matrix(list(), 5, 1)
BIC <- NULL
AIC <- NULL

# Fit models with 1 to 5 classes
for (x in 1:5) {
  lc[[x]] <- poLCA(f, data_selected, nclass = x)
  BIC[x] <- lc[[x]]$bic
  AIC[x] <- lc[[x]]$aic
}

# Extract predicted classes for the 5-class model
cluster <- lc[[5]]$predclass

# Combine the first column with the predicted classes
cluster_label <- cbind(eid, cluster)

# Write the combined data to a CSV file
write.csv(cluster_label, "/output/bs/All_Lamers.csv", row.names = FALSE)

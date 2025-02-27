# Ensure the HDclassif package is installed
if (!requireNamespace("HDclassif", quietly = TRUE)) {
  install.packages("HDclassif", repos = "http://cran.us.r-project.org")
}

# Load the HDclassif library
library(HDclassif)

# Load clinical features
data <- read.csv("Maglanoc_df.csv", header = FALSE)

# Load bootstrapped sample indices
bootstrap_samples <- read.csv("bootstrapped_samples_100.csv", header = TRUE)

# Rename columns
colnames(data) <- c("eid", paste0("V", 1:(ncol(data) - 1)))

# Loop through 100 iterations
for (iteration in 1:ncol(bootstrap_samples)) {
  
  # Get the indices for the current iteration
  current_eids <- bootstrap_samples[, iteration]
  
  # Subset the data for the current iteration
  data_iteration <- data[data$eid %in% current_eids, ]
  
  # Separate features and IDs
  data_selected <- data_iteration[, -1]
  eid <- data_iteration[, 1]
  
  # Run HDclassif with default settings 
  model <- hddc(data_selected, k=6)
  
  # Extract cluster assignments
  cluster <- model$class
  
  # Combine EIDs with cluster assignments
  cluster_label <- data.frame(eid = eid, cluster = cluster)
  
  # Write the results to a CSV file
  output_path <- paste0("/output/bs/Maglanoc/Maglanoc_bs_", iteration, ".csv")
  write.csv(cluster_label, output_path, row.names = FALSE)
  
  # Print progress
  cat("Completed iteration:", iteration, "\n")
}



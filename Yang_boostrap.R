library(cluster)
library(factoextra)

# Load input data
data <- read.csv("Yang_df.csv", header = FALSE)

# Load bootstrapped sample indices
bootstrap_samples <- read.csv("bootstrapped_samples_100.csv", header = TRUE)

# Rename columns in data
colnames(data) <- c("eid", paste0("V", 1:(ncol(data) - 1)))

# Loop through 100 bootstrap iterations
for (iteration in 1:ncol(bootstrap_samples)) {
  
  # Get the EIDs for the current iteration
  current_eids <- bootstrap_samples[, iteration]
  
  # Subset the data based on EIDs
  data_iteration <- data[data$eid %in% current_eids, ]
  
  # Check if the subset is empty
  if (nrow(data_iteration) == 0) {
    cat("Iteration", iteration, "has no data. Skipping.\n")
    next
  }
  
  # Separate features and IDs
  data_selected <- data_iteration[, -1]
  eid <- data_iteration[, 1]
  
  # Perform k-means clustering with K = 2 (as specified)
  set.seed(123)  # For reproducibility
  kmeans_result <- kmeans(data_selected, centers = 2)
  
  # Combine EIDs with cluster assignments
  cluster_label <- data.frame(eid = eid, cluster = kmeans_result$cluster)
  
  # Write the results to a CSV file
  output_path <- paste0("/output/bs/Yang/Yang_bs_", iteration, ".csv")
  write.csv(cluster_label, output_path, row.names = FALSE)
  
  # Print progress
  cat("Completed iteration:", iteration, "\n")
}


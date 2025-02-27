# Load cluster inputs (clinical features)
data <- read.csv("Lamers_df.csv", header = FALSE)
bootstrap_samples <- read.csv("bootstrapped_samples_100.csv", header = TRUE)

colnames(data) <- c("eid", paste0("V", 1:(ncol(data) - 1)))

library(poLCA)

for (iteration in 1:ncol(bootstrap_samples)) {
  current_eids <- bootstrap_samples[, iteration]
  data_iteration <- data[data$eid %in% current_eids, ]
  
  if (nrow(data_iteration) == 0) {
    cat("Iteration", iteration, "has no data. Skipping.\n")
    next
  }
  
  data_selected <- data_iteration[, -1]
  eid <- data_iteration[, 1]
  
  if (any(apply(data_selected, 2, var) == 0)) {
    cat("Iteration", iteration, "skipped due to low variability.\n")
    next
  }
  
  f <- as.formula(paste("cbind(", paste0("V", 1:ncol(data_selected), collapse = ", "), ") ~ 1"))
  
  lc <- matrix(list(), 5, 1)
  BIC <- NULL
  AIC <- NULL
  
  for (x in 1:min(5, nrow(data_selected) - 1)) {
    lc[[x]] <- poLCA(f, data_selected, nclass = x)
    BIC[x] <- lc[[x]]$bic
    AIC[x] <- lc[[x]]$aic
  }
  
  cluster <- lc[[min(5, nrow(data_selected) - 1)]]$predclass
  cluster_label <- cbind(eid, cluster)
  
  output_path <- paste0("Lamers_bs_", iteration, ".csv")
  write.csv(cluster_label, output_path, row.names = FALSE)
  
  cat("Completed iteration:", iteration, "\n")
}



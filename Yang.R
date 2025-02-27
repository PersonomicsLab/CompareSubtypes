library(cluster)
library(factoextra)

# Load input data
data <- read.csv("Yang_df.csv", header = FALSE)

# Select features (exclude first column) and the first column
data_selected <- data[, -1]
eid <- data[, 1]

# Verify column names
colnames(data_selected) <- paste0("V", 1:ncol(data_selected))

# Compute optimal K using silhouette method
silhouette_eval <- fviz_nbclust(data_selected, kmeans, method = "silhouette", k.max = 8)
sil <- silhouette_eval$data$k[which.max(silhouette_eval$data$y)]

# Compute optimal K using gap statistic
gap_eval <- clusGap(data_selected, kmeans, K.max = 8, B = 50) # B is the number of bootstraps
gap <- maxSE(gap_eval$Tab[, "gap"], gap_eval$Tab[, "SE.sim"], method = "firstmax")

# Compute optimal K using Calinski-Harabasz index
ch_eval <- fviz_nbclust(data_selected, kmeans, method = "wss", k.max = 8)
CH <- ch_eval$data$k[which.max(ch_eval$data$y)]

# Print optimal Ks
cat("Optimal K (Silhouette):", sil, "\n")
cat("Optimal K (Gap Statistic):", gap, "\n")
cat("Optimal K (Calinski-Harabasz):", CH, "\n")

# Final K selection (k = 2, as per comment)
k <- 2

# Perform k-means clustering
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(data_selected, centers = k)

cluster_label <- data.frame(eid = eid, cluster = kmeans_result$cluster)
write.csv(cluster_label, "/output/bs/All_Yang.csv", row.names = FALSE)


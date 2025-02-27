#make sure HDclassif is downloaded

#load clinical features
data <- read.csv("Maglanoc_df.csv", header = FALSE)

# Select features (exclude first column) and the first column
data_selected <- data[, -1]
eid <- data[, 1]

#run HDclassif using deafults, k=1-10
library(HDclassif)
model <- hddc(data_selected, k=6)
cluster <- model$class 

# Combine
cluster_label <- data.frame(eid=eid, cluster=cluster)

write.csv(cluster_label,'/output/bs/All_Maglanoc.csv', row.names=FALSE)


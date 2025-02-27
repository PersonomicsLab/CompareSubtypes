#make sure HDclassif is downloaded

#load clinical features
data <- read.csv("Maglanoc_zscored_clinicalfeatures_final.csv", header=FALSE)


#run HDclassif using deafults, k=1-10
library(HDclassif)
model <- hddc(data)
write.csv(model$class,'Maglanoc_clust_assignments_final.csv')


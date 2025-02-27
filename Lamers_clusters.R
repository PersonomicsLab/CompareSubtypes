#in matlab, I will have chosen the variable instances I want and I'll save it as csv
#load cluster inputs (clinical features)
data <- read.csv("Lamers_formatted_clinicalfeatures_final.csv", header=FALSE)

# load cluster package
library(poLCA)
f <- cbind(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12)~1

lc <-matrix(list(), 5, 1)
BIC <- NULL
AIC <- NULL
for (x in 1:5) {
  lc[[x]] <- poLCA(f,data,nclass= x )
  BIC[x] <- lc[[x]]$bic
  AIC[x] <- lc[[x]]$aic
}


class <- lc[[5]]$predclass
write.csv(class,'Lamers_clust_assignments_final.csv')

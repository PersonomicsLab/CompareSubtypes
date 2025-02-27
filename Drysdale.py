import numpy as np
import pandas as pd
from scipy.cluster.hierarchy import linkage, fcluster

# Load the dataset
data = pd.read_csv('Drysdale_df.csv')
data_input = data.iloc[:, 1:3] 
    
# Perform hierarchical clustering
linkage_matrix = linkage(data_input, method='ward')
labels = fcluster(linkage_matrix, t=3, criterion='maxclust')
            
# Save the results to CSV
labels_df = pd.DataFrame({'eid': data.iloc[:,0], 'cluster': labels})
output_path = '/output/all/All_Drysdale.csv'
labels_df.to_csv(output_path, index=False)
            
# Print progress
print(f'Output saved to {output_path}')


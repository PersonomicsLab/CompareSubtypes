import numpy as np
import pandas as pd
from scipy.cluster.hierarchy import linkage, fcluster
from sklearn.cluster import KMeans

data = pd.read_csv('Drysdale_df.csv')
sublist = pd.read_csv('bootstrapped_samples_100.csv')
num_iteration = 100

for i in range(num_iteration):
    # Select data for the current iteration
    data_eid = data[data['eid'].isin(sublist[f'iteration_{i+1}'])]
    data_input = data_eid.iloc[:,:2]
    
    for n_clusters in [2,3,5]:
        # Perform hierarchical clustering
        # linkage_matrix = linkage(data_input, method='ward')
        # labels = fcluster(linkage_matrix, t=n_clusters, criterion='maxclust')

        # Perform K-means clustering
        kmeans = KMeans(n_clusters=n_clusters, random_state=42)
        labels = kmeans.fit_predict(data_input)
        
        # Save the results to CSV
        labels_df = pd.DataFrame({'eid': data_eid['eid'], 'cluster': labels})
        labels_df.to_csv(f'/output/bs/Drysdale/{n_clusters}clusters_kmean/Drysdale_bs_{i+1}_{n_clusters}clusters.csv', index=False)
        
        print(f'Finished iteration {i+1}, # Clusters = {n_clusters}')

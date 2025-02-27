from mlni.hydra_clustering import clustering
import os

feature_tsv="/data/Wen_df.tsv"
output_dir = "/output/bs/Wen"
k_min=2
k_max=8
cv_repetition=100
clustering(feature_tsv, output_dir, k_min, k_max, cv_repetition, n_threads=16)

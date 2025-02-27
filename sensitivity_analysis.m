%% delta R2 sensitivity
%% run for clinical 
[R2_1, R2_2, deltaR, max_deltaR] = deltaR2_buff(clusters, clinical);

%% run for imaging
[R2_1_i, R2_2_i, deltaR_i, max_deltaR_i] = deltaR2_buff(clusters, imaging);

%% significant delta Rs
[keep_sig_c] = sigsfor_deltaR(deltaR_c, max_deltaR_c, clusters);

%% function to get delta R and max shuffled delta R

function [R2_1, R2_2, deltaR, max_deltaR] = deltaR2_buff(clusters, phenotypes)
% R2_1 = zeros(size(phenotypes, 2), size(clusters, 2));
% R2_2 = zeros(size(phenotypes, 2), size(clusters, 2));
% max_deltaR = zeros(size(phenotypes, 2), size(clusters, 2), size(clusters, 2));

for z = 1:size(phenotypes, 2)
    for x = 1:size(clusters, 2)
        for y = (x+1):size(clusters, 2)
            if istable(phenotypes)
                phenotype = phenotypes{:,z};
            else
                phenotype = phenotypes(:,z);
            end

            % select cluster assignments 
            clust_assign1 = clusters(:,x);
            clust_assign2 = clusters(:,y);
            
            % prep data
            nans = find(isnan(clust_assign1));
            clust_assign1(nans) = [];
            clust_assign2(nans) = [];
            phenotype(nans) = [];
            nans = find(isnan(clust_assign2));
            clust_assign1(nans) = [];
            clust_assign2(nans) = [];
            phenotype(nans) = [];
            nans = find(isnan(phenotype));
            clust_assign1(nans) = [];
            clust_assign2(nans) = [];
            phenotype(nans) = [];
            
            % GLM
            mdl1 = fitglm(categorical(clust_assign1), phenotype);
            mdl2 = fitglm(categorical(clust_assign2), phenotype);
            
            %%R squared
            R2_1{z}(x, y) = mdl1.Rsquared.Adjusted;
            R2_2{z}(x, y) = mdl2.Rsquared.Adjusted;
            
            %%delta R2 between subtypes approaches?
            %R2(i) - R2(j)
            deltaR{z}(x, y) = R2_1{z}(x, y) - R2_2{z}(x, y);
            
            %%permutation analysis
            % shuffle membership label of clusters
            % shuffle 2000 times
            for i = 1:2000
                idx = randperm(length(clust_assign1));
                clust_assign1_shuff = clust_assign1(idx);
                clust_assign2_shuff = clust_assign2(idx );
                mdl1_shuff = fitglm(categorical(clust_assign1_shuff(:,1)), phenotype(:,1));
                R2_1_shuff = mdl1_shuff.Rsquared.Adjusted;
                mdl2_shuff = fitglm(categorical(clust_assign2_shuff(:,1)), phenotype(:,1));
                R2_2_shuff = mdl2_shuff.Rsquared.Adjusted;
                deltaR_shuff(i) = R2_1_shuff - R2_2_shuff;
            end
            % get maximum delta R2 of the 15 pairwise comparisons for each 2000
            max_deltaR{z}(x, y) = max(abs(deltaR_shuff));
        end
        
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R2_1, R2_2, deltaR, max_deltaR] = deltaR2(clust_assign1, clust_assign2, phenotype)
% prep
nans = find(isnan(clust_assign1));
clust_assign1(nans) = [];
clust_assign2(nans) = [];
phenotype(nans) = [];
nans = find(isnan(clust_assign2));
clust_assign1(nans) = [];
clust_assign2(nans) = [];
phenotype(nans) = [];
nans = find(isnan(phenotype));
clust_assign1(nans) = [];
clust_assign2(nans) = [];
phenotype(nans) = [];

% GLM
mdl1 = fitglm(categorical(clust_assign1), phenotype);
mdl2 = fitglm(categorical(clust_assign2), phenotype);

%%R squared
R2_1 = mdl1.Rsquared.Adjusted;
R2_2 = mdl2.Rsquared.Adjusted;

%%delta R2 between subtypes approaches?
%R2(i) - R2(j)
deltaR = R2_1-R2_2;

%%permutation analysis
% shuffle membership label of clusters
% shuffle 2000 times
for i = 1:2000
    clust_assign1_shuff = clust_assign1(randperm(length(clust_assign1)));
    clust_assign2_shuff = clust_assign2(randperm(length(clust_assign2)));
    mdl1_shuff = fitglm(clust_assign1_shuff(:,1), phenotype(:,1));
    R2_1_shuff = mdl1_shuff.Rsquared.Ordinary;
    mdl2_shuff = fitglm(clust_assign2_shuff(:,1), phenotype(:,1));
    R2_2_shuff = mdl2_shuff.Rsquared.Ordinary;
    deltaR_shuff(i) = R2_1_shuff - R2_2_shuff;
end
max_deltaR = max(abs(deltaR_shuff));
end
% get maximum delta R2 of the 15 pairwise comparisons for each 2000 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [keep_sig_i] = sigsfor_deltaR(deltaR_i, max_deltaR_i, clusters)
for z = 1:size(deltaR_i, 2)
    for x = 1:size(clusters, 2)
        for y = (x+1):size(clusters, 2)
test_i{z} = abs(deltaR_i{z}) - max_deltaR_i{z};
test2_i{z} = abs(deltaR_i{z}) > max_deltaR_i{z};
if test2_i{z}(x,y) == 1
    if deltaR_i{z}(x,y) > 0
        keep_sig_i{z}(x,y) = 1; % 1 stands for R2_1
    elseif deltaR_i{z}(x,y) < 0
            keep_sig_i{z}(x,y) = 2; %2 stands for R2_2
    else 
        keep_sig_i{z}(x,y) = 0;
        end
else
    keep_sig_i{z}(x,y) = 0;
end
        end
    end
end
end
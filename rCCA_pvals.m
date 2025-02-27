%% load data
load('CCA_workspace.mat');
c = 2; % first 2 components
for i=1:c
cors{i} = corr(U(:,i), V(:,1));
end
sorted_perms{1} = sortrows(permutationtests.all_rCCA_cc1, 'descend');
sorted_perms{2} = sortrows(permutationtests.all_rCCA_cc2, 'descend');


for i = 1:c
sig{i} = ((sum(sorted_perms{i} > cors{i}))+1)/(length(sorted_perms{i})+1);
end
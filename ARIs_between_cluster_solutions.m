%% ARI
addpath('/Users/kayla/Library/CloudStorage/Box-Box/ThesisLab_April2021/ThesisProjectCode/Functions/') 
% load('all_clusters_final.mat')
for i = 1:size(clusters,2)
    for j = 1:size(clusters,2)
        ARIs(i,j) = rand_index(clusters(:,i), clusters(:,j), 'adjusted');
    end
end

%save('cluster_compare_ARI', 'ARIs', 'names')

for i = 1:6
    for j = 1:6
        if i == j
            ARIs(i,j) = NaN;
        end
    end
end
%% Permutation ARI
addpath('/Users/kayla/Library/CloudStorage/Box-Box/ThesisLab_April2021/ThesisProjectCode/Functions/') 

clear ARIs_shuff shuff_idx shuff_clust
for n = 1:2000
    shuff_idx = randi(length(clusters), [length(clusters),6]);
    shuff_clust = clusters(shuff_idx);
    
    for i = 1:size(clusters,2) 
    for j = 1:size(clusters,2)
        ARIs_shuff{i,j}(n) = rand_index(shuff_clust(:,i), shuff_clust(:,j), 'adjusted');
    end
    end
end

%% get the top 5% for ARI_shuff and see if ARIs (true) is greater than
for i = 1:size(clusters,2)
    for j = 1:size(clusters,2)
       ARI_sort = sort(ARIs_shuff{i,j}, 'descend');
       ARI_thresh(i,j) = ARI_sort(6);
       sig(i,j) = ARIs(i,j) > ARI_thresh(i,j);
    end
end

% save('ARI_results_9nov24.mat', 'ARI_thresh', 'ARIs', 'sig', 'names')

%% calculate pval
for i = 1:size(clusters,2)
    for j = 1:size(clusters,2)
       ARI_sort = sort(ARIs_shuff{i,j}, 'descend');
       pvals(i,j) = (sum(ARI_sort >= ARIs(i,j))+1)/(length(ARI_sort)+1);
    end
end

corrected_pvals = pvals*15; % bonferonni correction
%% how to determine the stability of the clusters through permutation? Doesn't that mean redoing the clustering?
%Wen already has an ARI outcome so we'll just use that
% pull clustering code from Price, Drysdale, Maglanoc, and Lamers
% this will have to be done in R for Maglanoc and Lamers
% is this really a priority?

approaches = {'Clinical+HDDC', 'Clinical+LCA', 'rfMRI+sGIMME', 'rfMRI+Wards', 'sMRI+HYDRA', 'sMRI+kmeans'};


figure('Position', [100 100 800 600])

% Create the heatmap using imagesc
h = imagesc(ARIs);

% heat map axis 0 to 1
caxis([-.1 .1]);

% Custom colormap from white to blue
n = 64;
colors = [linspace(1,0.1,n)', linspace(1,0.5,n)', ones(n,1)];
colormap(colors);

% Black out NaN values by setting their color directly
set(h, 'AlphaData', ~isnan(ARIs))
set(gca,'Color','k')  % Set background color to black

% Rest of your code...
c = colorbar;
c.Label.String = 'ARI';
c.FontSize = 18;

set(gca, 'XTick', 1:length(names), 'XTickLabel', approaches);
set(gca, 'YTick', 1:length(names), 'YTickLabel', approaches);
set(gca, 'FontSize', 16);
box on;

xtickangle(45);

% Add numeric values and asterisks
[rows, cols] = size(ARIs);
for i = 1:rows
    for j = 1:cols
        if isnan(ARIs(i,j))
            txt = 'NaN';
            textColor = 'w';  % White text for black background
        else
            txt = sprintf('%.3f', ARIs(i,j));
            % Determine text color based on background
            if ARIs(i,j) < 0.005
                textColor = 'k';
            else
                textColor = 'k';
            end
        end
        
        if sig(i,j)
            txt = [txt '*'];
        end
        
        text(j, i, txt, 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', 'FontSize', 16, ...
            'Color', textColor);
    end
end

axis square
set(gca, 'TickLength', [0 0]);
grid off;
title('Subject Overlap Between Approaches', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'LooseInset', get(gca, 'TightInset'))
print(gcf,'ReplicationProject_ARIs_24nov24','-dpng','-r300');

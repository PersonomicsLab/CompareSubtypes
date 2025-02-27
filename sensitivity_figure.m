%% new sensitivity figure

%% Clinical features not used in subtyping
BH_headers_all = clinical_headers([2:19, 22:27, 52, 74:81]);
% remove 3, 5, 7, 9, 11, 13, 14, 17, 19, 20, 23
BH_headers = BH_headers_all([1:2, 4, 6, 8, 10, 12, 15:16, 18, 21:22, 24:33]);
MH_headers_all = clinical_headers([1, 20:21, 28:51, 53:73]);
MH_headers = MH_headers_all([1:4, 6, 8, 10, 12:14, 18:19, 28:48]);

BH_idx_all = [2:19, 22:27, 52, 74:81];
BH_idx = BH_idx_all([[1:2, 4, 6, 8, 10, 12, 15:16, 18, 21:22, 24:33]]);
MH_idx_all = [1, 20:21, 28:51, 53:73];
MH_idx = MH_idx_all([1:4, 6, 8, 10, 12:14, 18:19, 28:48]);


R2_BH = R2(:, BH_idx);
R2_MH = R2(:, MH_idx);

%% readable headers
MH_names = {'Townsend deprivation','Depression onset','Depression episodes','Low mood (previous)', ...
    'Anhedonia (previous)','Restless (previous)','Lethargy (previous)','Anhedonia (previous)', ...
    'Low mood (previous)','Sleep issues (previous)','Trouble focus (previous)', ...
    'Motor changes (previous)','Loved as child','Abused as child','Hated as child', ...
    'Molested as child','Doctor visits as child','Confiding relationship as adult', ...
    'Physical violence as adult','Belittlement as adult','Non-consensual as adult', ...
    'Pay rent as adult','Sexual assault','Violent crime','Serious accident','Witness death' ...
    'Life threatening illness','Combat/war','Disturbing thoughts',...
    'Upset at stressful experience','Avoid activities','Feel distant','Irritable'};

BH_names = {'Age','Sex','BMI','Diabetes','Smoking','Diastolic BP (previous)',...
    'Diastolic BP (current)','Systolic BP (previous)', ...
    'Systolic BP (current)','Overall Health','Father illness',...
    'Mother illness (previous)','Mother illness (current)','C-reactive Protein',...
    'Reaction time','Numeric memory','Fluid intelligence','Trail making B',...
    'Trail making A','Symbol digit substitution','Paired associate learning','Prospective memory'};
%% remove the only non-significant clinical feature for B and C
MH_names(27) = [];
R2_MH(:, 27) = [];

%%
fig = figure();
fig.Position = [1 1 1280 696];
t = tiledlayout(2, 7, 'TileSpacing', 'loose', 'Padding', 'compact'); 

nexttile([1 7]); 

c = [0.1 0.35 0.8; ... % Rich blue
     0.26 0.65 1; ... % Light blue
     0.7 0.08 0.3; ... % Vivid pink
     1 0.5 0.7; ... % Soft pink
     .95 0.7 0; ... % Bright yellow
     1 0.9 0.55]; % Soft yellow
 
s = swarmchart(positions_sorted, R2s_nosig_sorted, [], c, 'filled');
s(1).XJitterWidth = 0.5;
s(2).XJitterWidth = 0.5; 
s(3).XJitterWidth = 0.5;
s(4).XJitterWidth = 0.5;
s(5).XJitterWidth = 0.5;
s(6).XJitterWidth = 0.5;
ylim([0, 0.305]);
xlim([0, 42]);
% set(gca, 'xtick', 1:length(modalities), 'xticklabels', modalities, 'fontsize', 12);
set(gca, 'xtick', 1:length(modalities), 'xticklabels', modalities);
% ylabel('Variance explained by subtype solution (R^2)', 'FontSize', 15);
ylabel('Variance explained by subtype solution (R^2)');
title('A. Sensitivity of Each Approach to Phenotypes Across Domains', 'Fontsize', 12);
grid on;

% Add group labels
ax = gca;
outer_pos = ax.OuterPosition; % Current outer position
tight_inset = ax.TightInset; % Margins around the axes
ax.Position = [outer_pos(1) + tight_inset(1), ...
               outer_pos(2) + tight_inset(2) + 0.05, ...
               outer_pos(3) - tight_inset(1) - tight_inset(3), ...
               outer_pos(4) - tight_inset(2) - tight_inset(4) - 0.1];
group_labels = {'Mental Health       ', 'Body Health       ', 'rfMRI Amplitudes       ', ...
                'rfMRI PNETs       ', 'Fractional Anisotropy       ', 'Cortical Thickness       '};
ticks_per_group = 7;
group_positions = ticks_per_group / 2 + (0:length(group_labels)-1) * ticks_per_group;
y_limits = ylim; % Get current y-axis limits
y_position = y_limits(1) - 0.23 * diff(y_limits); % Move further down
for i = 1:length(group_labels)
    text(group_positions(i), y_position, group_labels{i}, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
         'FontSize', 11.5, 'Units', 'data'); % 'data' ensures placement uses axes units

end

c = {[0.1 0.35 0.8], ... % Rich blue
     [0.26 0.65 1], ... % Light blue
     [0.7 0.08 0.3], ... % Vivid pink
     [1 0.5 0.7], ... % Soft pink
     [.95 0.7 0], ... % Bright yellow
     [1 0.9 0.55]}; % Soft yellow
nexttile([1 4]); 
hold on;
title('B. Mental Health Phenotypes', 'Fontsize', 12);
ylabel('Variance explained by subtype solution (R^2)');
for i = 1:6
    scatter(1:size(R2_MH, 2), R2_MH(i, :), 45, c{i}, 'filled'); % Plot each row
end
xticks([1:1:length(MH_names)]);
xticklabels(MH_names);
xlim([0, length(MH_names) + 1]);
ylim([0, .3]);
legend({'Clinical+HDDC', 'Clinical+LCA', 'rfMRI+sGIMME', 'rfMRI+Wards', 'sMRI+HYDRA', 'sMRI+kmeans'}, 'Location', 'northeast');
grid on;
hold off;

nexttile([1 3]); 
hold on;
title('C. Body Health Phenotypes', 'Fontsize', 12);
ylabel('Variance explained by subtype solution (R^2)');
for i = 1:6
    scatter(1:size(R2_BH, 2), R2_BH(i, :), 45, c{i}, 'filled'); % Plot each row
end
xticks([1:1:length(BH_headers)]);
xticklabels(BH_names);
xlim([0, length(BH_headers) + 1]);
ylim([0, .3]);
legend({'Clinical+HDDC', 'Clinical+LCA', 'rfMRI+sGIMME', 'rfMRI+Wards', 'sMRI+HYDRA', 'sMRI+kmeans'}, 'Location', 'northeast');
grid on;
hold off;



fig = gcf;
fig.Position = [1 1 1280 650]; % Increase figure size
exportgraphics(fig, 'R2_allinone.png', 'Resolution', 300);

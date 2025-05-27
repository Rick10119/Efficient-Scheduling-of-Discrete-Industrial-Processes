%% Analyze resource balance gap for all results
clc;
clear;

% Parameters to analyze
gaps = [1, 1e-1, 1e-2, 1e-3, 1e-4];
days = [5:8, 11:13, 15, 19:22, 26:28];
NOF_HEAT = 8;
% binding time interval, hour - 5 min = 5/60 hour
delta = 5 / 60;
% load the original parameters
load("./parameter_setting/param_zhang_2017.mat");

% Initialize arrays to store statistics
mean_gaps = zeros(length(gaps), 1);
max_gaps = zeros(length(gaps), 1);
min_gaps = zeros(length(gaps), 1);

% Process each result file
for i = 1:length(gaps)
    gap = gaps(i);
    gap_stats = [];
    
    for j = 1:length(days)
        day_index = days(j);
        
        % Load result file
        filename = sprintf("./results/flxb_crtn_day_%d_heat_%d_gap_", day_index, NOF_HEAT) + gap + ".mat";
        if exist(filename, 'file')
            load(filename);

            % the price for each time interval
            temp = param.price_days(:, day_index);
            NOF_INTERVAL = length(temp) / delta;
            new_index = linspace(1, length(temp), NOF_INTERVAL);
            price = interp1(1 : length(temp), temp, new_index)';
            add_crtn_param_and_var;
            
            % Get the resource values
            R_IT = result.R_IT;
            D_IKT = result.D_IKT;
            
            % Calculate the resource balance terms
            temp = repmat(G_IK, 1, 1, NOF_INTERVAL) .* D_IKT;  % production
            temp = permute(sum(temp, 2), [1, 3, 2]);  % production
            temp1 = [temp(2 : end, :); zeros(1, NOF_INTERVAL)];  % consumption
            
            % Calculate the gap for each resource and time interval
            gap_values = (R_IT(:, 2:end) - (R_IT(:, 1:end-1) + temp - temp1))/gap;
            
            % Store statistics for this day
            gap_stats = [gap_stats; mean(gap_values(:)), max(gap_values(:)), min(gap_values(:))];
            
            % Print statistics
            fprintf('Day %d, Gap %.0e:\n', day_index, gap);
            fprintf('  Mean gap: %.6f\n', mean(gap_values(:)));
            fprintf('  Max gap: %.6f\n', max(gap_values(:)));
            fprintf('  Min gap: %.6f\n\n', min(gap_values(:)));
        end
    end
    
    % Calculate average statistics across all days for this gap
    if ~isempty(gap_stats)
        mean_gaps(i) = mean(gap_stats(:,1));
        max_gaps(i) = mean(gap_stats(:,2));
        min_gaps(i) = mean(gap_stats(:,3));
    end
end

%% Create plots
close;
figure('Position', [100, 100, 1200, 400]);


% Plot mean gap
subplot(1,3,1);
semilogx(gaps, mean_gaps, 'o-', 'LineWidth', 2);
grid on;
ylim([-1, 1]);
xlabel('Gap Value');
ylabel('Mean Gap');
title('Average Mean Gap vs Gap Value');

% Plot max gap
subplot(1,3,2);
semilogx(gaps, max_gaps, 'o-', 'LineWidth', 2);
grid on;
ylim([-1, 1]);
xlabel('Gap Value');
ylabel('Max Gap');
title('Average Max Gap vs Gap Value');

% Plot min gap
subplot(1,3,3);
semilogx(gaps, min_gaps, 'o-', 'LineWidth', 2);
grid on;
ylim([-1, 1]);
xlabel('Gap Value');
ylabel('Min Gap');
title('Average Min Gap vs Gap Value');

% Adjust figure appearance
set(gcf, 'Color', 'white');
set(findall(gcf,'-property','FontSize'), 'FontSize', 12); 
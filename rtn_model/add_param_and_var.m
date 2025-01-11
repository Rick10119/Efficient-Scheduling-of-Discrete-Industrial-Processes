%% parameters of the RTN model
clc;yalmip("clear");% clear;
% binding time interval, hour - 5 min = 5/60 hour
delta = 5 / 60;
NOFHOUR = 24;
NOF_INTERVAL = NOFHOUR / delta;

% load the original parameters
load("..\parameter_setting\param_zhang_2017.mat");

% energy price of  day_index
temp = param.price_days(:, day_index);% the price for each time interval
new_index = linspace(1, 24, NOF_INTERVAL);
price = interp1(1 : 24, temp, new_index)';

% number of processes
NOF_PROCESS = length(param.nominal_power);

% processing time slots
param.processing_slot = ceil(param.processing_time / delta / 60);

% max waiting time of final product：NOF_INTERVAL (relaxed)
param.processing_slot(end) = NOF_INTERVAL;

%% number/index of tasks (processing, transfer) for each heat
NOF_TASK = NOF_PROCESS * (NOF_HEAT * 2);
index_task_processing = 1 : (NOF_HEAT * 2) : NOF_TASK;
index_task_transfer = 2 : (NOF_HEAT * 2) : NOF_TASK;

%%  number/index of resources (device, mat_s, mat_d)
NOF_RESOURCE = NOF_PROCESS * (1 + NOF_HEAT * 2);
index_resource_device = 1 : (1 + NOF_HEAT * 2) : NOF_RESOURCE;
index_resource_mat_s = 2 : (1 + NOF_HEAT * 2) : NOF_RESOURCE;% index of the first heat
index_resource_mat_d = 3 : (1 + NOF_HEAT * 2) : NOF_RESOURCE;% index of the first heat

% index of resource_mat_s_heat
temp = 1 : NOF_RESOURCE - 1;
for process_index = 1 : NOF_PROCESS
    % reduce the device indices
    temp(index_resource_device(process_index)) = 2;% 2 is the first index for mat_s
    % reduce the mat_d indices
    for heat_index = 1 : NOF_HEAT
        temp(index_resource_mat_d(process_index) + (heat_index - 1) * 2) = 2;
    end
end
% reduce the redundant elements
index_resource_mat_s_heat = unique(temp);

% index of resource_mat_d_heat
temp = 1 : NOF_RESOURCE;
for process_index = 1 : NOF_PROCESS
    % reduce the device indices
    temp(index_resource_device(process_index)) = 3;% 3 is the first index for mat_d
    % reduce the mat_s indices
    for heat_index = 1 : NOF_HEAT
        temp(index_resource_mat_s(process_index) + (heat_index - 1) * 2) = 3;
    end
end
% reduce the redundant elements
index_resource_mat_d_heat = unique(temp);

%% mu(r, i, theta): change of resource r by task i after theta time slots
% largest duration of the tasks
max_tau = max(param.processing_slot(1, :));

% initilize the mu matrix
MU_RIT = zeros(NOF_RESOURCE, NOF_TASK, 1 + max_tau);

for process_index = 1 : NOF_PROCESS
    for heat_index = 1 : NOF_HEAT
        %% processing task
        % processing task -> resource_device, t consumes r at onces, and
        % recovers r after tau
        % reduce
        MU_RIT(index_resource_device(process_index), ...
            index_task_processing(process_index) + (heat_index - 1) * 2, 1) = -1;
        % recover
        MU_RIT(index_resource_device(process_index), ...
            index_task_processing(process_index) + (heat_index - 1) * 2, ...
            1 + param.processing_slot(1, process_index)) = 1;% tau slots after t
        
        % processing task -> resource_mat_d, t consumes r-1 after tau
        if process_index >1 % the first process only consumes raw material
            MU_RIT(index_resource_mat_d(process_index - 1) + (heat_index - 1) * 2, ...
                index_task_processing(process_index) + (heat_index - 1) * 2, 1) = - 1;
        end
        % processing task -> resource_mat_s, t produces r after tau
        MU_RIT(index_resource_mat_s(process_index) + (heat_index - 1) * 2, ...
            index_task_processing(process_index) + (heat_index - 1) * 2, ...
            1 + param.processing_slot(1, process_index)) = 1;
        
        
        %% transfer task
        % transfer task -> resource_mat_s, t consumes r at onces
        MU_RIT(index_resource_mat_s(process_index) + (heat_index - 1) * 2, ...
            index_task_transfer(process_index) + (heat_index - 1) * 2, 1) = - 1;
        
        % transfer task -> resource_mat_d, t produces r after tau
        MU_RIT(index_resource_mat_d(process_index) + (heat_index - 1) * 2, ...
            index_task_transfer(process_index) + (heat_index - 1) * 2, ...
            1 + param.processing_slot(2, process_index)) = 1;
    end
end

%% variables

% value of resource i at time t
R_RT = binvar(NOF_RESOURCE, NOF_INTERVAL + 1, 'full');

% starting time flag of task i: 1 for starting at t
N_IT = binvar(NOF_TASK, NOF_INTERVAL, 'full');



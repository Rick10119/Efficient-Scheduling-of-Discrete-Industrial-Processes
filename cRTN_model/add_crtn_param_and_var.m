%% parameters of the cRTN model



% number of processes
NOF_PROCESS = length(param.nominal_power);

% production target
% NOF_HEAT = 9;
% NOF_HEAT = param.production_target;

%% number/index of tasks (processing, output, waiting, input) for each heat
NOF_TASK = NOF_PROCESS * 4;
index_task_processing = 1 : 4 : NOF_TASK;
index_task_output = 2 : 4 : NOF_TASK;
index_task_waiting = 3 : 4 : NOF_TASK;
index_task_input = 4 : 4 : NOF_TASK;

%%  number/index of resources (mat_s, mat_o, mat_w mat_d)
NOF_RESOURCE = NOF_PROCESS * 4;
index_resource_mat_s = 1 : 4 : NOF_RESOURCE;
index_resource_mat_o = 2 : 4 : NOF_RESOURCE;
index_resource_mat_w = 3 : 4 : NOF_RESOURCE;
index_resource_mat_d = 4 : 4 : NOF_RESOURCE;

%% G(i, k): change of resource r(i) by task i(r) operating at point k
% p.s., r and i are indexed in the same way

% initialize the mu matrix
NOF_POINT = 3; % number of operating points of the devices
G_IK = zeros(NOF_TASK, NOF_POINT);

% processing time (reshape to NOF_TASK * 1)
processing_time_I = reshape([param.processing_time; zeros(1, NOF_PROCESS)], NOF_TASK, 1);
processing_time_I(find(processing_time_I< delta * 60)) = delta * 60;

% processing task 
G_IK(index_task_processing, 2) = delta ./ (processing_time_I(index_task_processing)/60);
G_IK(index_task_processing(1), 3) = G_IK(index_task_processing(1), 2);% the same

% output task (in 1 time slot)
G_IK(index_task_output, 2) = 1;

% waiting task (lower bound: transfer time, upper bound: max waiting time)(+ delta to compensate the async error)
G_IK(index_task_waiting, 3) = delta ./ (processing_time_I(index_task_waiting - 1)/60 + delta);
G_IK(index_task_waiting, 2) = delta ./ (processing_time_I(index_task_waiting)/60 + delta);
% final product
G_IK(index_task_waiting(end), 2 : 3) = 1;


% input task (in 1 time slot)
G_IK(index_task_input, 2) = 1;

% max value
G_IK(find(G_IK > 1)) = 1;

%% P(i, k): consuming power of task i(r) operating at point k
P_IK = zeros(size(G_IK));
P_IK(index_task_processing, 2) = param.nominal_power;
% melting task (0.75, 1.25)
P_IK(1, 2 : 3) = P_IK(1, 2) * [0.75, 1.25];

%% variables

% value of resource i at time t
R_IT = sdpvar(NOF_RESOURCE, NOF_INTERVAL + 1, 'full');

% operating duration of task i on point n in t (in time slots)
D_IKT = sdpvar(NOF_TASK, NOF_POINT, NOF_INTERVAL, 'full');

% binvar to model D * R = 0 for some processes
u_RT = binvar(NOF_PROCESS * 2, NOF_INTERVAL);

% binvar to model output/input task
on_RT = binvar(NOF_PROCESS * 2, NOF_INTERVAL);
% binvar to model processing task (not melting)
on_IKT = binvar(3, NOF_INTERVAL);



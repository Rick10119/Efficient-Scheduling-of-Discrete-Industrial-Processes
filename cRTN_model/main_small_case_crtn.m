%% flexible cRTN model, illustrated by a small case

%% read parameters & define variables
yalmip("clear");

delta = 60 / 60;% 1 hour

% load the original parameters
load(".\parameter_setting\param_small_case.mat");
NOF_INTERVAL = length(param.price_days);
NOF_HEAT = param.production_target;

% energy price of  July 26
day_index = 26;
temp = param.price_days(:, day_index);% the price for each time interval
% temp = temp(1:12);
new_index = linspace(1, 24, NOF_INTERVAL);
price = interp1(1 : 24, temp, new_index)';

% on basis of crtn model
add_crtn_param_and_var;

% index of melting tasks
index_task_melting = 1;

% modify the G matrix: melting power: 0.75-1.25
G_IK(index_task_melting, 2 : 3) = G_IK(index_task_melting, 2) * [0.75, 1.25];


%% add flexible rtn constraints
cons = [];
% basic rtn constraints to cons
add_crtn_cons;


%% hourly electricity consumption (15)
temp = repmat(P_IK, 1, 1, NOF_INTERVAL);% form a matrix for nonimal power
E_T = delta * permute(sum(sum(temp .* D_IKT, 1), 2), [1, 3, 2]);% 1 * NOF_INTERVAL

%% Objective
% minimize the total energy cost
cost = E_T * price;

%% solve
TimeLimit = 7200;
% ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 0, ...
%     'gurobi.TimeLimit', TimeLimit);
ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 1,  ...
    'gurobi.TimeLimit', TimeLimit);
ops.gurobi.TuneTimeLimit = TimeLimit;

sol = optimize(cons, cost, ops)

%% save
result = {};
result.E_T = value(E_T);
result.R_IT = value(R_IT);
result.D_IKT = value(D_IKT);

% save("..\results\flxb_crtn\flxb_crtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat", "result", "sol");
% save("..\results\time\flxb_crtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat", "result", "sol");




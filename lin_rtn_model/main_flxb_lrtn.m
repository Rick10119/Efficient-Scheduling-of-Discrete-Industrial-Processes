%% flexible rtn model

%% read parameters & define variables
% on basis of lrtn model
add_lrtn_param_and_var;

% index of melting tasks
index_task_melting = 1;

% modify the G matrix: melting power: 0.75-1.25
G_IK(index_task_melting, 2 : 3) = G_IK(index_task_melting, 2) * [0.75, 1.25];


%% add flexible rtn constraints
cons = [];
% basic rtn constraints
add_basic_lrtn_cons;
cons = [cons, cons_basic_lrtn];

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

% save("..\results\flxb_lrtn\flxb_lrtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat", "result", "sol");
% save("..\results\time\flxb_lrtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat", "result", "sol");




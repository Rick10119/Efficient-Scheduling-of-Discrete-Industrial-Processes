%% flexible cRTN model, illustrated by a small case

%% read parameters & define variables
yalmip("clear");

delta = 60 / 60;% 1 hour

% load the original parameters
load(".\parameter_setting\param_small_case.mat");
NOF_INTERVAL = length(param.price_days);
NOF_HEAT = param.production_target;

scenario = 1;
price = param.price_days(:, scenario);

% add variables and parameters
add_crtn_param_and_var;

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

% add the quadratic term of the total energy cost
% to avoid multiple solutions
cost = cost + sum(sum(E_T .* E_T));

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

% save
save(".\results\crtn_small_case_scenario_" + scenario + ".mat", "result", "sol");




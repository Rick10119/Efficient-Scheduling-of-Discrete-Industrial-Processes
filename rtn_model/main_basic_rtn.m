%% basic rtn model

%% read parameters & define variables
add_rtn_param_and_var;

%% add basic rtn constraints
cons = [];
add_basic_rtn_cons;


%% hourly electricity consumption (2)
temp = repmat(param.nominal_power', 1, NOF_INTERVAL);% form a matrix for nonimal power
E_T = sum((1 - R_RT(index_resource_device, 2 : end)) .* temp) * delta;

%% Objective
% minimize the total energy cost
cost = E_T * price;

%% solve
% TimeLimit = 30;
% ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 1, ...
%     'gurobi.TimeLimit', TimeLimit);
ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 1);

sol = optimize(cons, cost, ops)

%% save
result = {};
result.E_T = value(E_T);
result.N_IT = value(N_IT);
result.R_RT = value(R_RT);


save(".\results\basic_rtn_" + NOF_HEAT + "_heat.mat", "result", "sol");

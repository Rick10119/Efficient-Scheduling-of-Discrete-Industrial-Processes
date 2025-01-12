%% flexible rtn model for small case

%% read parameters & define variables
yalmip("clear");

delta = 60 / 60;% 1 hour

% load the original parameters
load(".\parameter_setting\param_small_case.mat");
NOF_INTERVAL = length(param.price_days);
NOF_HEAT = param.production_target;

scenario = 2;
price = param.price_days(:, scenario);

% add variables and parameters
add_rtn_param_and_var;

% index of melting tasks
index_task_melting = 1 : 2 : 2 * NOF_HEAT;

% modify the MU matrix: following replaced by (12)-(15)
% melting task "doesn't" consume device
MU_RIT(index_resource_device(1), index_task_melting, :) = 0;
% melting task "doesn't" produce mat_s
MU_RIT(index_resource_mat_s_heat(1 : NOF_HEAT), index_task_melting, :) = 0;
% transfer task "doesn't" consume mat_s
MU_RIT(index_resource_mat_s_heat(1 : NOF_HEAT), index_task_melting + 1, :) = 0;

% min/max melting time slots
power_ratio_L = param.melting_power_ratio(1);
power_ratio_H = param.melting_power_ratio(2);
param.tau_L = ceil(param.processing_time(1) / delta / 60 / power_ratio_H);
param.tau_U = ceil(param.processing_time(1) / delta / 60 / power_ratio_L);

% min/max melting power
param.P_L = param.nominal_power(1) * power_ratio_L;
param.P_U = param.nominal_power(1) * power_ratio_H;

% add variables
% melting status: 1 for melting at t
S_HT = binvar(NOF_HEAT, NOF_INTERVAL, 'full');

% melting power
P_HT = sdpvar(NOF_HEAT, NOF_INTERVAL, 'full');

%% add flexible rtn constraints
cons = [];
% basic rtn constraints
add_basic_rtn_cons;

% flxb rtn constraints
add_flxb_rtn_cons;


%% hourly electricity consumption (15)
% form a matrix for nonimal power (of the last three processes)
temp = repmat(param.nominal_power(2 : end)', 1, NOF_INTERVAL);
E_T = sum((1 - R_RT(index_resource_device(2 : end), 2 : end)) .* temp) * delta + ...
    sum(P_HT, 1) * delta;% energy for the melting task

%% Objective
% minimize the total energy cost
cost = E_T * price;

% add the quadratic term of the total energy cost
% to avoid multiple solutions
cost = cost + sum(sum(E_T .* E_T));

%% solve
TimeLimit = 120;
% ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 0, ...
%     'gurobi.TimeLimit', TimeLimit);
ops = sdpsettings('debug',0,'solver','GUROBI', 'verbose', 0,  ...
    'gurobi.TimeLimit', TimeLimit);
ops.gurobi.TuneTimeLimit = 7200;
sol = optimize(cons, cost, ops)

if sol.problem ~= 0
    % 这将打印无解的约束
    for i = 1:length(cons)
        if any(checkset(cons(i)) < 0)
            % cons(i)
            disp(i)
        end
    end
end

%% save
result = {};
result.E_T = value(E_T);
result.N_IT = value(N_IT);
result.R_RT = value(R_RT);
result.S_HT = value(S_HT);
result.P_HT = value(P_HT);

% save
save(".\results\flxb_rtn_small_case_scenario_" + scenario + ".mat", "result", "sol");






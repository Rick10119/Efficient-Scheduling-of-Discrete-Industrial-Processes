%% flexible cRTN model
% settings to be changed:
% NOF_HEAT, day_index, gap

%% read parameters & define variables
yalmip("clear");
% binding time interval, hour - 5 min = 5/60 hour
delta = 60 / 60;

% load the original parameters
load(".\parameter_setting\param_zhang_2017.mat");
% if day_index is not provided, set it to 26
if ~exist('day_index', 'var')
    day_index = 26;
end
% if NOF_HEAT is not provided, set it to 3
if ~exist('NOF_HEAT', 'var')
    NOF_HEAT = 3;
end
% if gap is not provided, set it to 0.01
if ~exist('gap', 'var')
    gap = 1e-4;
end
% the price for each time interval
temp = param.price_days(:, day_index);
NOF_INTERVAL = length(temp) / delta;
new_index = linspace(1, length(temp), NOF_INTERVAL);
price = interp1(1 : length(temp), temp, new_index)';

% add variables and parameters
add_crtn_param_and_var;

%% add crtn constraints
cons = [];

% add constraints
add_crtn_cons;

%% hourly electricity consumption (15)
temp = repmat(P_IK, 1, 1, NOF_INTERVAL);% form a matrix for nonimal power
E_T = delta * permute(sum(sum(temp .* D_IKT, 1), 2), [1, 3, 2]);% 1 * NOF_INTERVAL

%% Objective
% minimize the total energy cost
cost = E_T * price;

%% solve
TimeLimit = 7200;
% set the solver, time limit, and optimality gap
ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 1,  ...
    'gurobi.TimeLimit', TimeLimit, 'gurobi.MIPGap', gap);
ops.gurobi.TuneTimeLimit = TimeLimit;

sol = optimize(cons, cost, ops)

%% save
result = {};
result.E_T = value(E_T);
result.R_IT = value(R_IT);
result.D_IKT = value(D_IKT);

% save according to the day_index, NOF_HEAT, and gap
save(".\results\flxb_crtn_day_" + day_index + "_heat_" + NOF_HEAT + "_gap_" + gap + ".mat", "result", "sol");





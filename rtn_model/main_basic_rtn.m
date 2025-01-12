%% basic rtn model
% settings to be changed:
% NOF_HEAT, day_index, gap

%% read parameters & define variables
yalmip("clear");

% load the original parameters
load(".\parameter_setting\param_zhang_2017.mat");

% binding time interval, hour - 5 min = 5/60 hour
delta = 60 / 60;

% if day_index is not provided, set it to 26
if ~exist('day_index', 'var')
    day_index = 26;
end
% if gap is not provided, set it to 1e-5
if ~exist('gap', 'var')
    gap = 1e-5;
end
% if NOF_HEAT is not provided, set it to 3
if ~exist('NOF_HEAT', 'var')
    NOF_HEAT = 3;
end

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

ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 1);

sol = optimize(cons, cost, ops)

%% save
result = {};
result.E_T = value(E_T);
result.N_IT = value(N_IT);
result.R_RT = value(R_RT);


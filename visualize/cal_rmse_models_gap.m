%% 统计各模型的误差（用能曲线/用能成本）
NOF_HEAT = 8;
Day_index = [5:8, 11:13, 15, 19:22, 26:28];

%% RTN model
rtn_value_e = [];
rtn_value_c = [];
rtn_time = [];

% add_rtn_param_and_var;
% load the original parameters
load(".\parameter_setting\param_zhang_2017.mat");
NOF_INTERVAL = 24*12;

for day_index = Day_index

price = param.price_days(:, day_index);% the price for each time interval
new_index = linspace(1, 24, NOF_INTERVAL);
price = interp1(1 : 24, price, new_index)';
gap = 1e-1;
load(".\results\flxb_rtn_day_" + day_index + "_heat_" + NOF_HEAT + "_gap_" + gap + ".mat");

rtn_value_c = [rtn_value_c, result.E_T * price];

result.E_T = sum(reshape(result.E_T, NOF_INTERVAL/24, 24));


rtn_value_e = [rtn_value_e, result.E_T];

end


%% RTN model
crtn_value_e = [];
crtn_value_c = [];
gap = 1e-4;
for day_index = Day_index

price = param.price_days(:, day_index);% the price for each time interval
new_index = linspace(1, 24, NOF_INTERVAL);
price = interp1(1 : 24, price, new_index)';

load(".\results\flxb_rtn_day_" + day_index + "_heat_" + NOF_HEAT + "_gap_" + gap + ".mat");

crtn_value_c = [crtn_value_c, result.E_T * price];

result.E_T = sum(reshape(result.E_T, NOF_INTERVAL/24, 24));

crtn_value_e = [crtn_value_e, result.E_T];

end


%% 计算RMSE-crtn
rmse_e_crtn = mean((crtn_value_e - rtn_value_e).^2);
rmse_c_crtn = mean((crtn_value_c - rtn_value_c).^2);

rmse_e_crtn = sqrt(rmse_e_crtn);
rmse_c_crtn = sqrt(rmse_c_crtn);

rmse_e_crtn/max(rtn_value_e)
100*rmse_c_crtn/max(rtn_value_c)



%%
% plot(rtn_value_e-crtn_value_e);hold on
% plot(crtn_value_e);hold on
% plot(rtn_value_e);
% legend("true-value", "irtn")
% plot(crtn_value_c);hold on
% plot(rtn_value_c);
% A = abs(rtn_value_e-crtn_value_e);
% A = sum(reshape(A, 12, 30));
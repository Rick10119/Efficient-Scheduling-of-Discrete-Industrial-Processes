%% 统计各模型的误差（用能曲线/用能成本）
NOF_HEAT = 8;
% Day_index = [15];
Day_index = [5:8, 11:13, 15, 19:22, 26:28];
%% RTN model
rtn_value_e = [];
rtn_value_c = [];
rtn_time = [];

cd ..\rtn_model\
add_param_and_var;
cd ..\visualize\

for day_index = Day_index

price = param.price_days(:, day_index);% the price for each time interval
new_index = linspace(1, 24, NOF_INTERVAL);
price = interp1(1 : 24, price, new_index)';

load("..\results\time\flxb_rtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");

rtn_value_c = [rtn_value_c, result.E_T * price];

result.E_T = sum(reshape(result.E_T, NOF_INTERVAL/24, 24));


rtn_value_e = [rtn_value_e, result.E_T];

end


%% lRTN model
lrtn_value_e = [];
lrtn_value_c = [];

for day_index = Day_index

price = param.price_days(:, day_index);% the price for each time interval
new_index = linspace(1, 24, NOF_INTERVAL);
price = interp1(1 : 24, price, new_index)';

load("..\results\time\flxb_lrtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");

lrtn_value_c = [lrtn_value_c, result.E_T * price];

result.E_T = sum(reshape(result.E_T, NOF_INTERVAL/24, 24));

lrtn_value_e = [lrtn_value_e, result.E_T];

end


%% 计算RMSE-lrtn
rmse_e_lrtn = mean((lrtn_value_e - rtn_value_e).^2);
rmse_c_lrtn = mean((lrtn_value_c - rtn_value_c).^2);

rmse_e_lrtn = sqrt(rmse_e_lrtn);
rmse_c_lrtn = sqrt(rmse_c_lrtn);

rmse_e_lrtn/max(rtn_value_e)
100*rmse_c_lrtn/max(rtn_value_c)



%%
% plot(rtn_value_e-lrtn_value_e);hold on
% plot(lrtn_value_e);hold on
% plot(rtn_value_e);
% legend("true-value", "irtn")
% plot(lrtn_value_c);hold on
% plot(rtn_value_c);
% A = abs(rtn_value_e-lrtn_value_e);
% A = sum(reshape(A, 12, 30));
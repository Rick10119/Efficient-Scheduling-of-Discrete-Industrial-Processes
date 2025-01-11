% price
NOF_HEAT = 8;
cd ..\rtn_model\
add_param_and_var;
cd ..\visualize\

day_index = 15;
price = param.price_days(:, day_index);% the price for each time interval


% RTN model
% load("..\results\flxb_rtn_5min_6_heat_day_26.mat");
load("..\results\time\flxb_rtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");



true_value_e = result.E_T;


% lRTN model
load("..\results\time\flxb_lrtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");
temp = length(result.E_T)/24;
lrtn_value_e = result.E_T;

plot(true_value_e);hold on 
plot(lrtn_value_e);
legend("RTN","cRTN")
%% parameter settings for the small case

% for io
param = {};

%% prcessing parameters
% excel file for the original parameters
filename = ".\parameter_setting\load_parameters_small_case.xlsx";

% nominal_power
param.nominal_power = xlsread(filename, 'nominal_power');

% processing_time
param.processing_time = xlsread(filename, 'processing_time');

% production target
param.production_target = 2;

% melting_power_ratio
param.melting_power_ratio = xlsread(filename, 'melting_power_ratio');

%% electricity price

price_days = [100, 100, 100, 100, 200, 200; ...
    100, 100, 100, 200, 200, 100]';

param.price_days = price_days;
clear price day_price

save(".\parameter_setting\param_small_case.mat", "param")





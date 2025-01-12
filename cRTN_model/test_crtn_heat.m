%% test the time of different NOF_HEAT, with the different day_index and default gap(1e-4)
clc;
clear;

for NOF_HEAT = [1, 2, 3, 4, 5, 6, 7, 8]
    for day_index = [5:8, 11:13, 15, 19:22, 26:28]
        disp("day_index: " + day_index);
        disp("NOF_HEAT: " + NOF_HEAT);
        main_flxb_crtn;
    end
end








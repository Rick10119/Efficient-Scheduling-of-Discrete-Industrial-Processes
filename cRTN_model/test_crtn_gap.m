%% test the result of different gap, with the default NOF_HEAT(8) on different day_index
clc;
clear;

NOF_HEAT = 8;

for gap = [1, 1e-1, 1e-2, 1e-3, 1e-4]
    for day_index = [5:8, 11:13, 15, 19:22, 26:28]
        disp("day_index: " + day_index);
        disp("gap: " + gap);
        main_flxb_crtn;
    end
end







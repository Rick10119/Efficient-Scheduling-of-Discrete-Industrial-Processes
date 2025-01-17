%% To plot the calculation time of the models with different gap

% Day_index = [5:8, 11:13, 15, 19:22, 26:28];
Day_index = [5:8, 11:13, 15];


%% RTN model

rtn_time = [];
Heat_index = [8];
for gap = [1, 1e-1, 1e-2, 1e-3]

    rtn_time_day = [];

    for day_index = Day_index

        load(".\results\flxb_rtn_day_" + day_index + "_heat_" + NOF_HEAT + "_gap_" + gap + ".mat");

        rtn_time_day = [rtn_time_day, sol.solvertime];

    end

    rtn_time = [rtn_time, mean(rtn_time_day)];

end
rtn_time = [rtn_time, 15000]/60;% 15000 is the limit of the solver


%% cRTN model
crtn_time = [];
NOF_HEAT = 8;
for gap = [1, 1e-1, 1e-2, 1e-3, 1e-4]

    crtn_time_day = [];

    for day_index = Day_index

        load(".\results\flxb_crtn_day_" + day_index + "_heat_" + NOF_HEAT + "_gap_" + gap + ".mat");

        crtn_time_day = [crtn_time_day, sol.solvertime];

    end

    crtn_time = [crtn_time, mean(crtn_time_day)/60];

end



%% plot

linewidth = 1;

plot(rtn_time, "--ob", 'linewidth', linewidth); hold on;
plot(crtn_time, "--<r", 'linewidth', linewidth); hold on;

% 轴属性
ax = gca;
ax.YLim = [0, 120];
ax.XLim = [1, 5];

legend('RTN','cRTN', ... % 'RTN-fast','cRTN-fast', ...
    'fontsize',13.5, ...
    'Location','NorthWest', ...
    'Orientation','vertical', ...
    'FontName', 'Times New Roman');
set(gca, "YGrid", "on");

%设置figure各个参数
y1 = ylabel('Calculation Time (minute)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
x1 = xlabel('Optimality Gap','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 1.5 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);



% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:5];
ax.YTick = [0, 30, 60, 120];

% 调整标签
ax.XTickLabel =  {"1e0", '1e-1', '1e-2', '1e-3', '1e-4'};
ax.YTickLabel =  {0, 30, 60, 120};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19, 7.8]);

saveas(gcf,'.\visualize\calculation_time_gap.pdf');


%% 画出所需时间

Day_index = [5:8, 11:13, 15, 19:22, 26:28];
Heat_index = [1:8];
%% RTN model

rtn_time = [];

for NOF_HEAT = Heat_index

    rtn_time_day = [];

    for day_index = Day_index

        load("..\results\time\flxb_rtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");

        rtn_time_day = [rtn_time_day, sol.solvertime];

    end

    rtn_time = [rtn_time, mean(rtn_time_day)];

end
rtn_time = [rtn_time, 15000];


%% cRTN model
lrtn_time = [];

for NOF_HEAT = [1:10]

    rtn_time_day = [];

    for day_index = Day_index

        load("..\results\time\flxb_lrtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");

        if sol.solvertime > 7200 % over the limit
            sol.solvertime = 7200;
        end
        rtn_time_day = [rtn_time_day, sol.solvertime];

    end

    lrtn_time = [lrtn_time, mean(rtn_time_day)];

end



%% plot

linewidth = 1;

% semilogy(rtn_time, "--ob", 'linewidth', linewidth); hold on;
% semilogy(lrtn_time, "--<r", 'linewidth', linewidth); hold on;
% semilogy(rtn_acl_time, "-->g", 'linewidth', linewidth); hold on;
% semilogy(lrtn_acl_time, "--*m", 'linewidth', linewidth); hold on;

plot(rtn_time, "--ob", 'linewidth', linewidth); hold on;
plot(lrtn_time, "--<r", 'linewidth', linewidth); hold on;
% plot(rtn_acl_time, "-->g", 'linewidth', linewidth); hold on;
% plot(lrtn_acl_time, "--*m", 'linewidth', linewidth); hold on;


% 轴属性
ax = gca;
ax.XLim = [0, 11];
ax.YLim = [0, 10000];

legend('RTN','cRTN', ... % 'RTN-fast','cRTN-fast', ...
    'fontsize',13.5, ...
    'Location','NorthWest', ...
    'Orientation','vertical', ...
    'FontName', 'Times New Roman');
set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Number of Heats','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Calculation Time (Second)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 1.5 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);



% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:10];
ax.YTick = [0, 1800, 3600, 7200];

% 调整标签
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19, 7.8]);

saveas(gcf,'calculation_time.pdf');


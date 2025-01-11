%% 画出负荷基线曲线（第一天）
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


temp = length(result.E_T)/24;
true_value_e = sum(reshape(result.E_T, temp, 24));
true_value_c = true_value_e * price;

% lRTN model
load("..\results\time\flxb_lrtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");
temp = length(result.E_T)/24;
lrtn_value_e = sum(reshape(result.E_T, temp, 24));
lrtn_value_c = lrtn_value_e * price;




%% 画图

linewidth = 1;
plot(1 : 24, true_value_e, "-ob", 'linewidth', linewidth); hold on;
plot(1 : 24, lrtn_value_e, "-->r", 'linewidth', linewidth); hold on;

% rmse_e_lrtn = sqrt(mean((lrtn_value_e - true_value_e).^2))/max(true_value_e);

% 轴属性
ax = gca;
ax.XLim = [0, 25];     
ax.YLim = [0, 150]; 
y1 = ylabel('Energy Consumption (MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


% 画电池电量（右轴）
yyaxis right
plot(1:24, price, "-.g", 'linewidth', linewidth);

% ax = gca;ax.YLim = [0, 300];
ax.YColor = 'black';

legend('Energy Consumption-RTN','Energy Consumption-cRTN','Electricity Price', ...    
'fontsize',13.5, ...
    'Location','southeast', ...
'Orientation','horizontal', ...
'NumColumns', 1, ...
'FontName', 'Times New Roman'); 
% set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Electricity Price ($/MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

    
  
% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:24];

% 调整标签
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [20, 10]);

saveas(gcf,'typical_load.pdf');
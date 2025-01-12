%% 示意某一天的价格、用能、各环节用能

%% market parameters

delta_t = 1;
hour_init = 1;
NOFSLOTS = 24 / delta_t;

% July 2022 rt system energy price from PJM
price_days = [];
for day_price = 1 : 31

start_row = (day_price-1) * 24 + hour_init + 1;
filename = '.\parameter_setting\rt_hrl_lmps.xlsx';
sheet = 'rt_hrl_lmps'; 
xlRange = "I" + start_row + ":I" + (start_row + NOFSLOTS - 1); 
price = xlsread(filename, sheet, xlRange);
price_days = [price_days, price];% $/MWh

end




%% 画图
%
linewidth = 1;
Day_index = [5:8, 11:13, 15, 19:22, 27:28];
plot(1:24, price_days(:, Day_index), 'linewidth', linewidth);

% ax = gca;ax.YLim = [0, 300];



%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Electricity Price ($/MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 1.6 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% 轴属性
ax = gca;
ax.XLim = [1, 24];

% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:24];

% 调整标签
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19.4, 7.8]);

saveas(gcf,'.\parameter_setting\price.pdf');



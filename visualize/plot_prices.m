%% the prices of the month




%% 画图
%
linewidth = 2;

% 实际能量
bar(P_val', 0.4,'stacked','DisplayName','P_val');hold on;

y1 = ylabel('Energy Consumption (kWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
% ax.YLim = [0, 90];
% 画电池电量（右轴）
yyaxis right



plot(1:24, 1e3 * Price, "-.g", 'linewidth', linewidth);

ax = gca;ax.YLim = [0, 300];
ax.YColor = 'black';

legend('Blender','Classifier','Crusher', ...
    'Classifier', ...
    'Crusher', ...
    'Separator', ...
    'Dryer', ...
    'Dehydrator', ...
    'Atomizer', ...
    'Reduction', ...
    'Price', ...
    'fontsize',13.5, ...
    'Location','EastOutside', ...
    'Orientation','vertical', ...
    'FontName', 'Times New Roman');
% set(gca, "YGrid", "on");

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
ax.XLim = [0, 25];

% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:24];

% 调整标签
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19.4, 7.8]);

saveas(gcf,'price.pdf');



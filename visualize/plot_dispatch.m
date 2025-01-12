%% 画出各个工厂能量的分解
% 点乘
temp = value(T_hnp) .* repmat(permute(F_e_np, [1, 3, 2]), 1, 1, 1, NOFINTERVALS);
temp = reshape(permute(temp, [2, 3, 1, 4]), NOFPOINTS, NOFMACHINES, NOFFACTORIES, NOFINTERVALS);
% 对工作点求和
temp = reshape(sum(temp), NOFMACHINES, NOFFACTORIES, NOFINTERVALS);
% 对机器求和
temp = reshape(sum(temp), NOFFACTORIES, NOFINTERVALS)';

% 画图

linewidth = 1;

plot(1 : 24, temp, 'linewidth', linewidth);hold on;
plot([8, 8], [0 350], "--black", 'linewidth', linewidth); 
plot([13, 13], [0 350], "--black", 'linewidth', linewidth); hold on;

set(gca, "YGrid", "on");


%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Energy Consumption (kWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');



% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% 轴属性
ax = gca;
ax.XLim = [0, 25];     
% ax.YLim = [150, 300];     
  
% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:24];

% 调整标签
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [18, 10]);

saveas(gcf,'.\visualize\dispatch.pdf');
% close;



%% STN
% 点乘
temp = value(I_hnp) .* repmat(permute(F_e_np, [1, 3, 2]), 1, 1, 1, NOFINTERVALS);
temp = reshape(permute(temp, [2, 3, 1, 4]), NOFPOINTS, NOFMACHINES, NOFFACTORIES, NOFINTERVALS);
% 对工作点求和
temp = reshape(sum(temp), NOFMACHINES, NOFFACTORIES, NOFINTERVALS);
% 对机器求和
temp = reshape(sum(temp), NOFFACTORIES, NOFINTERVALS)';
plot(temp);


% 画图

linewidth = 1;

plot(1 : 24, temp, 'linewidth', linewidth);hold on;
plot([8, 8], [0 350], "--black", 'linewidth', linewidth); 
plot([13, 13], [0 350], "--black", 'linewidth', linewidth); hold on;

set(gca, "YGrid", "on");


%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Energy Consumption (kWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');



% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% 轴属性
ax = gca;
ax.XLim = [0, 25];     
% ax.YLim = [150, 300];     
  
% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:24];

% 调整标签
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [18, 10]);

saveas(gcf,'dispatch_milp.pdf');
close;
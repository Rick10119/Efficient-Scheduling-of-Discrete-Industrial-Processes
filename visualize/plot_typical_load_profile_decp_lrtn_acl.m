%% 画出负荷基线曲线（第一天）
clear;
day_index = 26;
cd ..\lin_rtn_model\
add_lrtn_param_and_var;
cd ..\visualize\

NOF_HEAT = 10;
% RTN model
% load("..\results\flxb_rtn_5min_6_heat_day_26.mat");
load("..\results\flxb_lrtn\flxb_lrtn_acl_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");

temp = repmat(P_IK, 1, 1, NOF_INTERVAL);% form a matrix for nonimal power
P_val = delta * permute(sum(temp .* result.D_IKT, 2), [1, 3, 2]);% 1 * NOF_INTERVAL
P_val = P_val(index_task_processing, :);
temp = length(result.E_T)/24;

p1 = P_val(1, :);p1 = sum(reshape(p1, temp, 24));
p2 = P_val(2, :);p2 = sum(reshape(p2, temp, 24));
p3 = P_val(3, :);p3 = sum(reshape(p3, temp, 24));
p4 = P_val(4, :);p4 = sum(reshape(p4, temp, 24));
P_val = [p1;p2;p3;p4];
% % lRTN model
% load("..\results\flxb_lrtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");
% temp = length(result.E_T)/24;
lrtn_value_e = sum(reshape(result.E_T, temp, 24));
% lrtn_value_c = lrtn_value_e * price;
% 
% % lRTN model acl
% load("..\results\flxb_lrtn_acl_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");
% temp = length(result.E_T)/24;
% lrtn_value_e_acl = sum(reshape(result.E_T, temp, 24));
% lrtn_value_c_acl = lrtn_value_e_acl * price;



%% 画图

% 实际能量
bar(P_val', 0.5,'stacked','DisplayName','P_val');hold on;

linewidth = 1;
plot(1:24, lrtn_value_e, "->r", 'linewidth', linewidth);

% 轴属性
ax = gca;
ax.XLim = [0, 25];     
ax.YLim = [0, 150]; 


legend('EAF','AOD','LF','CC', "total consumption",...    
'fontsize',13.5, ...
    'Location','northeast', ...
'Orientation','horizontal', ...
'NumColumns', 1, ...
'FontName', 'Times New Roman'); 
% set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Electricity consumption (MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


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

saveas(gcf,'typical_load_decp_lrtn.pdf');
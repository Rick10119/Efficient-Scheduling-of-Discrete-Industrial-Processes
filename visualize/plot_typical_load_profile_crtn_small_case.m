%% to plot the typical load profile of the small case, cRTN
clear;
main_small_case_crtn;

% form a matrix for nonimal power (of the last three processes)
temp = repmat(P_IK, 1, 1, NOF_INTERVAL);% form a matrix for nonimal power
P_val = delta * permute(sum(temp .* result.D_IKT, 2), [1, 3, 2]);% 1 * NOF_INTERVAL
P_val = P_val(index_task_processing, :);
temp = length(result.E_T)/24;

p1 = P_val(1, :);
p2 = P_val(2, :);
p3 = P_val(3, :);
p4 = P_val(4, :);
P_val = [p1;p2;p3;p4];
% % crtn model
% load("..\results\flxb_crtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");
% temp = length(result.E_T)/24;
% crtn_value_e = sum(reshape(result.E_T, temp, 24));
% crtn_value_c = crtn_value_e * price;
% 
% % crtn model acl
% load("..\results\flxb_crtn_acl_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");
% temp = length(result.E_T)/24;
% crtn_value_e_acl = sum(reshape(result.E_T, temp, 24));
% crtn_value_c_acl = crtn_value_e_acl * price;



%% 画图

% 实际能量
area(P_val', 'LineStyle','none');hold on;

% linewidth = 1;
% plot(1:24, crtn_value_e, "-ob", 'linewidth', linewidth);

% 轴属性
ax = gca;
ax.XLim = [1, 48];     
ax.YLim = [6, 10]; 


legend('EAF','AOD','LF','CC', "total consumption",...    
'fontsize',13.5, ...
    'Location','southeast', ...
'Orientation','horizontal', ...
'NumColumns', 1, ...
'FontName', 'Times New Roman'); 
% set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Time','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Electricity consumption (MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

    
  
% 字体与大小
ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [1:3:49];
m=linspace(datenum(0 + ":00",'HH:MM'),datenum(4 + ":00",'HH:MM'),17);
% set(gca,'xtick',2:0.2:3);
for n=1:length(m)
    tm{n}=datestr(m(n),'HH:MM');
end
set(gca,'xticklabel',tm);

% 调整标签
% ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [20, 10]);

saveas(gcf,'.\visualize\typical_load_decp_crtn.pdf');
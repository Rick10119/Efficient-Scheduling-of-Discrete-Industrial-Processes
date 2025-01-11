%% 画出负荷基线曲线（第一天）
clear;
day_index = 15;NOF_HEAT = 8;
cd ..\rtn_model\
add_param_and_var;
cd ..\visualize\

% RTN model
% load("..\results\flxb_rtn_5min_6_heat_day_26.mat");
load("..\results\time\flxb_rtn_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");

% form a matrix for nonimal power (of the last three processes)
temp = repmat(param.nominal_power(2 : end)', 1, NOF_INTERVAL);
P_val = ((1 - result.R_RT(index_resource_device(2 : end), 2 : end)) .* temp) * delta;
P_val =  [sum(result.P_HT, 1) * delta; P_val];% energy for the melting task
temp = length(result.E_T)/24;

p1 = P_val(1, :);
p2 = P_val(2, :);
p3 = P_val(3, :);
p4 = P_val(4, :);
% p1 = sum(reshape(p1, temp, 24));
% p2 = sum(reshape(p2, temp, 24));
% p3 = sum(reshape(p3, temp, 24));
% p4 = sum(reshape(p4, temp, 24));
P_val = [p1;p2;p3;p4];
P_val = P_val(:, 1:48);
% lrtn_value_e = sum(reshape(result.E_T, temp, 24));
% lrtn_value_c = lrtn_value_e * price;
% 
% % lRTN model acl
% load("..\results\flxb_lrtn_acl_5min_" + NOF_HEAT + "_heat_day_" + day_index + ".mat");
% temp = length(result.E_T)/24;
% lrtn_value_e_acl = sum(reshape(result.E_T, temp, 24));
% lrtn_value_c_acl = lrtn_value_e_acl * price;



%% 画图

% 实际能量
area(P_val', 'LineStyle','none');hold on;

% linewidth = 1;
% plot(1:24, lrtn_value_e, "-ob", 'linewidth', linewidth);

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

saveas(gcf,'typical_load_decp_rtn.pdf');
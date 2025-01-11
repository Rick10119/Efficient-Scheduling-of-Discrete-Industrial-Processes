%% input task demo

% data preparation
x1 = []










%%
ax1 = subplot(4,1,1);
plot(x1, y1)

ax2 = subplot(4,1,2);
plot(x2, y2)

ax3 = subplot(4,1,3);
plot(x3, y3)

ax4 = subplot(4,1,4);
plot(x4, y4)

linkaxes([ax1,ax2,ax3,ax4],'x'); % 让所有子图的x轴对齐

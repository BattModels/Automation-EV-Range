%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Aniruddh Mohan, Shashank Sripad, Parth Vaishnav, and Venkatasubramanian Viswanathan    %
% Carnegie Mellon University, Pittsburgh, Pennsylvania,15213, USA.                                %
% email address: aniruddh@cmu.edu, ssripad@cmu.edu                                                %
% Last revision: May 2020                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
fsize = 18;
lw = 2;
color.lblue = [0,0.635294117647059,0.831372549019608]; %rgb triplet
color.orange = [0.925490196078431,0.400000000000000,0.0274509803921569]; %rgb triplet


[figure2a_data, figure2a_head, ~] = xlsread('figure2.xls','figure2a');
figure2a = table(figure2a_data(:,1),figure2a_data(:,2));
figure2a.Properties.VariableNames = figure2a_head;

[figure2a_lines_data, figure2a_lines_head, ~] = xlsread('figure2.xls','figure2a_lines');
figure2a_lines = table(figure2a_lines_data(:,1),figure2a_lines_data(:,2),figure2a_lines_data(:,3));
figure2a_lines.Properties.VariableNames = figure2a_lines_head;

[figure2b_data, figure2b_head, ~] = xlsread('figure2.xls','figure2b');
figure2b = table(figure2b_data(:,1),figure2b_data(:,2));
figure2b.Properties.VariableNames = figure2b_head;

[figure2b_lines_data, figure2b_lines_head, ~] = xlsread('figure2.xls','figure2b_lines');
figure2b_lines = table(figure2b_lines_data(:,1),figure2b_lines_data(:,2),figure2b_lines_data(:,3));
figure2b_lines.Properties.VariableNames = figure2b_lines_head;

figure(1)
subplot(2,1,1)
h(1) = histogram(figure2a.AEV_with_LiDAR, 50);
hold on
h(2) = histogram(figure2a.AEV_without_LiDAR, 50);
hold on
plot([figure2a_lines.Median_range_without_LiDAR figure2a_lines.Median_range_without_LiDAR], [0 1000], 'color',color.orange,'linewidth',lw,'linestyle','--')
hold on
plot([figure2a_lines.Model_3_EV_range figure2a_lines.Model_3_EV_range], [0 1000], '--k','linewidth',lw)
hold on
plot([figure2a_lines.Median_range_with_LiDAR figure2a_lines.Median_range_with_LiDAR], [0 1000], 'color',color.lblue,'linewidth',lw,'linestyle','--')
xlabel('Vehicle range (miles)')
ylabel('Frequency')
set(h(1),'Facecolor',color.lblue,'EdgeColor',color.lblue,'FaceAlpha',0.4,'EdgeAlpha',0);
set(h(2),'Facecolor',color.orange,'EdgeColor',color.orange,'FaceAlpha',0.4,'EdgeAlpha',0);
text(figure2a_lines.Median_range_with_LiDAR-6.5,100,'Median range','FontWeight','normal','FontName','Helvetica Neue','FontSize',fsize,'color',color.lblue,'rotation',90)
text(figure2a_lines.Model_3_EV_range-6.5,100,'Model 3 EV range','FontWeight','normal','FontName','Helvetica Neue','FontSize',fsize,'color','k','rotation',90)
text(figure2a_lines.Median_range_without_LiDAR-6.5,100,'Median range','FontWeight','normal','FontName','Helvetica Neue','FontSize',fsize,'color',color.orange,'rotation',90)
text(215,550,'a','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize )
set(gcf,'color','w','Position',[0,0,600,700])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
legend('AEV with LiDAR','AEV without LiDAR')
legend boxoff
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
xlim([250 490])
ylim([0 550])

subplot(2,1,2)
h(1) = histogram(figure2b.AEV_with_LiDAR, 50);
hold on
h(2) = histogram(figure2b.AEV_without_LiDAR, 50);
hold on
plot([figure2b_lines.Median_range_without_LiDAR figure2b_lines.Median_range_without_LiDAR], [0 1000], 'color',color.orange,'linewidth',lw,'linestyle','--')
hold on
plot([figure2b_lines.Model_3_city_range figure2b_lines.Model_3_city_range], [0 1000], '--k','linewidth',lw)
hold on
plot([figure2b_lines.Median_range_with_LiDAR figure2b_lines.Median_range_with_LiDAR], [0 1000], 'color',color.lblue,'linewidth',lw,'linestyle','--')
xlabel('Vehicle range (miles)')
ylabel('Frequency')
set(h(1),'Facecolor',color.lblue,'EdgeColor',color.lblue,'FaceAlpha',0.4,'EdgeAlpha',0);
set(h(2),'Facecolor',color.orange,'EdgeColor',color.orange,'FaceAlpha',0.4,'EdgeAlpha',0);
text(figure2b_lines.Median_range_with_LiDAR-6.5,100,'Median range','FontWeight','normal','FontName','Helvetica Neue','FontSize',fsize,'color',color.lblue,'rotation',90)
text(figure2b_lines.Model_3_city_range-6.5,100,'Model 3 city range','FontWeight','normal','FontName','Helvetica Neue','FontSize',fsize,'color','k','rotation',90)
text(figure2b_lines.Median_range_without_LiDAR-6.5,100,'Median range','FontWeight','normal','FontName','Helvetica Neue','FontSize',fsize,'color',color.orange,'rotation',90)
text(215,550,'b','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
set(gcf,'color','w','Position',[0,0,600,700])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
legend('AEV with LiDAR','AEV without LiDAR')
legend boxoff
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
xlim([250 490])
ylim([0 550])

print(gcf,'-painters','-djpeg','Figure2.jpeg')
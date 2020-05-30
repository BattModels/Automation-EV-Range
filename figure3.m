%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Aniruddh Mohan, Shashank Sripad, Parth Vaishnav, and Venkatasubramanian Viswanathan    %
% Carnegie Mellon University, Pittsburgh, Pennsylvania,15213, USA.                                %
% email address: aniruddh@cmu.edu, ssripad@cmu.edu                                                %
% Last revision: May 2020                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
fsize = 18;

[figure3a_data, figure3a_head, ~] = xlsread('figure3.xls','figure3a');
figure3a = table(figure3a_data(:,1),figure3a_data(:,2),figure3a_data(:,3),figure3a_data(:,4),figure3a_data(:,5),...
    figure3a_data(:,6),figure3a_data(:,7),figure3a_data(:,8),figure3a_data(:,9),figure3a_data(:,10));

[figure3b_data, figure3b_head, ~] = xlsread('figure3.xls','figure3b');
figure3b = table(figure3b_data(:,1),figure3b_data(:,2),figure3b_data(:,3),figure3b_data(:,4),figure3b_data(:,5),...
    figure3b_data(:,6),figure3b_data(:,7),figure3b_data(:,8),figure3b_data(:,9),figure3b_data(:,10));

figure3a_group = [ones(1e4,1);
         2 * ones(1e4,1);
         3* ones(1e4,1);
         4* ones(1e4,1);
         5* ones(1e4,1);
         6* ones(1e4,1);
         7* ones(1e4,1);
         8* ones(1e4,1);
         9* ones(1e4,1);
         10* ones(1e4,1)];
     
figure3b_group = [ones(1e4,1);
         2 * ones(1e4,1);
         3* ones(1e4,1);
         4* ones(1e4,1);
         5* ones(1e4,1);
         6* ones(1e4,1);
         7* ones(1e4,1);
         8* ones(1e4,1);
         9* ones(1e4,1);
         10* ones(1e4,1)];

figure()
subplot(2,1,1)
boxplot(figure3a_data, figure3a_group)
set(gca,'xtick',[mean(1:2) mean(3:4) mean(5:6) mean(7:8) mean(9:10)])
set(gca,'xticklabel',{'Tesla Model 3','Tesla Model S', 'Chevy Bolt', 'Nissan Leaf', 'Xpeng G3'},'xticklabelrotation',30)
color = ['c', 'y', 'c', 'y', 'c', 'y', 'c', 'y', 'c', 'y'];
set(gca,'ytick',[-25 -20 -15 -10 -5 0 5 10 15 20 25])
set(gca,'YTickLabel',{'-25%','-20%','-15%','-10%','-5%','0%','5%','10%','15%','20%','25%'})
ylabel('(Range_{AEV}-Range_{EV})/Range_{EV}')
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.5);
end
c = get(gca, 'Children');
legend(c(1:2), 'Without LiDAR', 'With LiDAR' );
set(gcf,'color','w','Position',[0,0,600,1000])
ylim([-25 25])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
legend boxoff
text(-2.15,25,'a','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])

subplot(2,1,2)
boxplot(table2array(figure3b), figure3b_group)
set(gca,'xtick',[mean(1:2) mean(3:4) mean(5:6) mean(7:8) mean(9:10)])
set(gca,'xticklabel',{'Tesla Model 3','Tesla Model S', 'Chevy Bolt', 'Nissan Leaf', 'Xpeng G3'},'xticklabelrotation',30)
color = ['c', 'y', 'c', 'y', 'c', 'y', 'c', 'y', 'c', 'y'];
set(gca,'ytick',[-30 -25 -20 -15 -10 -5 0 5 10 15 20 25])
set(gca,'YTickLabel',{'-30%','-25%','-20%','-15%','-10%','-5%','0%','5%','10%','15%','20%','25%'})
ylabel('(Range_{AEV}-Range_{EV})/Range_{EV}')
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.5);
end
c = get(gca, 'Children');
legend(c(1:2), 'Without LiDAR', 'With LiDAR' );
set(gcf,'color','w','Position',[0,0,600,1000])
ylim([-30 25])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
legend boxoff
text(-2.15,25,'b','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])

print(gcf,'-painters','-djpeg','Figure3.jpeg')
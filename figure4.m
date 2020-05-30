%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Aniruddh Mohan, Shashank Sripad, Parth Vaishnav, and Venkatasubramanian Viswanathan    %
% Carnegie Mellon University, Pittsburgh, Pennsylvania,15213, USA.                                %
% email address: aniruddh@cmu.edu, ssripad@cmu.edu                                                %
% Last revision: May 2020                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
fsize =18;
lw = 3.5;

[figure4a_data, figure4a_head, ~] = xlsread('figure4.xls','figure4a');
figure4a = table(figure4a_data(:,1),figure4a_data(:,2),figure4a_data(:,3),figure4a_data(:,4),figure4a_data(:,5));
figure4a.Properties.VariableNames = figure4a_head;

[figure4b_data, figure4b_head, ~] = xlsread('figure4.xls','figure4b');
figure4b = table(figure4b_data(:,1),figure4b_data(:,2),figure4b_data(:,3),figure4b_data(:,4),figure4b_data(:,5));
figure4b.Properties.VariableNames = figure4b_head;

figure()
subplot(1,2,1)
plot(figure4a.miles_thousands,figure4a.soh_aev5,'linewidth',lw)
hold on
plot(figure4a.miles_thousands,figure4a.soh_aev50,'linewidth',lw)
hold on
plot(figure4a.miles_thousands,figure4a.soh_aev95,'linewidth',lw)
hold on
plot(figure4a.miles_thousands,figure4a.soh_ev,'linewidth',lw-1,'color','k')
xlabel('Odometer (thousand miles)')
ylabel('State-of-Health')
set(gcf,'color','w','Position',[0,0,1200,450])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
set(gca,'ytick',[0.8 0.85 0.9 0.95 1])
set(gca,'YTickLabel',{'80%','85%','90%','95%','100%'})
legend('5th Percentile AEV','Median AEV','95th Percentile AEV','EV')
legend boxoff
text(-25,1,'a','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
ylim([0.8 1])
xlim([0 120])

subplot(1,2,2)
plot(figure4b.miles_thousands,figure4b.soh_aev5,'linewidth',lw)
hold on
plot(figure4b.miles_thousands,figure4b.soh_aev50,'linewidth',lw)
hold on
plot(figure4b.miles_thousands,figure4b.soh_aev95,'linewidth',lw)
hold on
plot(figure4b.miles_thousands,figure4b.soh_ev,'linewidth',lw-1,'color','k')
xlabel('Odometer (thousand miles)')
ylabel('State-of-Health')
set(gcf,'color','w','Position',[0,0,1200,450])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
set(gca,'ytick',[0.8 0.85 0.9 0.95 1])
set(gca,'YTickLabel',{'80%','85%','90%','95%','100%'})
legend('5th Percentile AEV','Median AEV','95th Percentile AEV','EV')
legend boxoff
text(-25,1,'b','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
ylim([0.8 1])
xlim([0 120])

print(gcf,'-painters','-djpeg','Figure4.jpeg')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Aniruddh Mohan, Shashank Sripad, Parth Vaishnav, and Venkatasubramanian Viswanathan    %
% Carnegie Mellon University, Pittsburgh, Pennsylvania,15213, USA.                                %
% email address: aniruddh@cmu.edu, ssripad@cmu.edu                                                %
% Last revision: May 2020                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
fsize = 18;
color.blue = [0,0,1]; %rgb triplet
color.red = [1,0,0]; %rgb triplet

[figure1a_data, figure1a_head, ~] = xlsread('figure1.xls','figure1a');
figure1a = table(figure1a_data(:,1),figure1a_data(:,2),figure1a_data(:,3));
figure1a.Properties.VariableNames = figure1a_head;

[figure1b_data, figure1b_head, ~] = xlsread('figure1.xls','figure1b');
figure1b = table(figure1b_data(:,1),figure1b_data(:,2),figure1b_data(:,3));
figure1b.Properties.VariableNames = figure1b_head;

[figure1c_data, figure1c_head, ~] = xlsread('figure1.xls','figure1c');
figure1c = table(figure1c_data(:,1),figure1c_data(:,2),figure1c_data(:,3));
figure1c.Properties.VariableNames = figure1c_head;

[figure1d_data, figure1d_head, ~] = xlsread('figure1.xls','figure1d');
figure1d = table(figure1d_data(:,1),figure1d_data(:,2),figure1d_data(:,3));
figure1d.Properties.VariableNames = figure1d_head;

figure()
subplot(2,2,1)
p1 = plot(figure1a.Time_min, figure1a.Velocity_mps_EV, 'color',color.blue,'linewidth',4,'linestyle','-');
p1.Color(4) = 0.6;
hold on
plot(figure1a.Time_min, figure1a.Velocity_mps_AEV, 'color',color.red,'linewidth',2)
xlabel('Time (min)')
ylabel('Velocity (m/s)')
set(gcf,'color','w','Position', [0, 0, 1100, 600])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
text(-5,30,'a','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
legend('EV','AEV')
legend boxoff


subplot(2,2,2)
p1 = plot(figure1b.Time_min, figure1b.Velocity_mps_EV, 'color',color.blue,'linewidth',4,'linestyle','-');
p1.Color(4) = 0.6;
hold on
plot(figure1b.Time_min, figure1b.Velocity_mps_AEV, 'color',color.red,'linewidth',2)
xlabel('Time (min)')
ylabel('Velocity (m/s)')
set(gcf,'color','w','Position', [0, 0, 1100, 600])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
text(9.5,20,'b','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
xlim([10 13])
legend('EV','AEV')
legend boxoff


subplot(2,2,3)
p1 = plot(figure1c.Time_min, figure1c.Power_kW_EV, 'color',color.blue,'linewidth',4,'linestyle','-');
p1.Color(4) = 0.6;
hold on
plot(figure1c.Time_min, figure1c.Power_kW_AEV, 'color',color.red,'linewidth',2)
xlabel('Time (min)')
ylabel('Power (kW)')
set(gcf,'color','w','Position', [0, 0, 1100, 600])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
text(-5,60,'c','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
legend('EV','AEV')
legend boxoff

subplot(2,2,4)
p1 = plot(figure1d.Time_min, figure1d.Power_kW_EV, 'color',color.blue,'linewidth',4,'linestyle','-');
p1.Color(4) = 0.6;
hold on
plot(figure1d.Time_min, figure1d.Power_kW_AEV, 'color',color.red,'linewidth',2)
xlabel('Time (min)')
ylabel('Power (kW)')
set(gcf,'color','w','Position', [0, 0, 1100, 600])
set(gca,'FontName','Helvetica Neue','FontSize',fsize,'FontWeight','normal','LineWidth',1,'layer','top','TickLength', [.015 .045])
set(gca,'TickDir','out')
text(9.5,30,'d','FontWeight','bold','FontName','Helvetica Neue','FontSize',fsize)
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',1);
axes(a)
linkaxes([a b])
xlim([10 13])
legend('EV','AEV')
legend boxoff

print(gcf,'-painters','-djpeg','Figure1.jpeg')

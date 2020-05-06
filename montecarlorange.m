function [] = montecarlorange(vehicle_weight)

%Tesla Model 3 vehicle only weight is 1280 kg

A = csvread('EPA_LA92Cycle.csv');     	%This file is the original EPA California Unified LA92 cycle but with all velocity values converted to m/s. The original drive profile in mph is available here: (https://www.nrel.gov/transportation/drive-cycle-tool/) 

new_t = A(1:1436,1);  					%time vector created
new_v = A(1:1436,2); 					%velocity vector created

ordist = trapz(new_t,new_v)./1.6e3   	%Confirm distance of drive cycle is 9.8 miles

pUDDS_i(:,1) = new_t;   				%creation of time vector in power array

%vehicle specifications
Crr = 0.0071;  				%rolling friction coefficient 

%%%Tesla Model 3
Area_f = 2.22; 				%this is tesla model 3 frontal area in meters squared
capacity = 80;   			%kWh of tesla battery pack
batteryweight=553;			%Battery weight in kg of tesla model 3 estimated 
basecd = 0.23;				%Cd of Tesla Model 3
evrange = 310;				%Range in miles of Tesla Model 3 EV only for a composite cycle such as the California Unified LA92 cycle used here.

%If you want to run the other vehicles just uncomment the one you want and add in the vehicle specs including the vehicle weight when calling the function 

%Define distributions for Monte Carlo Simulations						
es = makedist('Uniform','Lower',0.9, 'Upper',0.9987);				%distribution for 1-smoothing parameter used in fit function in Matlab
sensor = makedist('Uniform','Lower', 30,'Upper',150);				%Uniform distribution for sensor load between 30 to 150 W

%Run monte carlo simulations for composite cycle without LiDAR
for i=1:10000
	x(i) = 0;													% percentage increase in drag when no LiDAR or solid state 
																
	Cd = basecd + ((x(i)/100)*basecd);    						%new drag is original drag + percentage increase above

	lambda(i) = random(es, 1,1);          						%1-smoothing parameter sampled for energy savings

	sensor_power(i) = round(random(sensor,1,1));				%sample sensor load 
	
	comp_power(i) = 7.1*sensor_power(i) - 63;					%correlate computational load to sensor load 

	avweight = 20;												%weight of all autonomous components 

	mass_i = vehicle_weight + avweight + batteryweight;			%calculate total vehicle mass including battery, car only weight, and autonomous system weight

	%%% run spline function for vehicle drive smoothing for incorporating energy savings 

	cf = fit(new_t(1:1436),new_v(1:1436),'smoothingspline','SmoothingParam',1-lambda(i));
	new_t4 = new_t;								%same time vector as previously 
	v4 = cf(new_t(1:1436));
	v4(v4<0) = 0;								%correct all terms below zero to zero
	new_v4 = v4;								%new smoothed velocity profile 
	a4 = diff(new_v4)./diff(new_t4);			%calculate acceleration by differentiating v and t
	a4_1 = [0;a4];								%correct for acceleration vector length by shifting initial acceleration
	a4_2 = [a4;0];								%correct for acceleration vector length by shifting final acceleration
	dvdt_i_4 = (a4_1 + a4_2) /2;				%final acceleration value is average of both values [this has to be done to improve the time resolution of our drive cycle data as the correct acceleration is in between the velocity points]

	smoothdist = trapz(new_t4,new_v4)./1.6e3;		%calculate range of smoothed profile, should be the almost the same as original distance

	for n=1:length(dvdt_i_4)
		P_Cd(n,:) = ((0.5*1.225*Cd*Area_f) .* (new_v4(n).^3));					%Calculate drag force
		P_friction(n,:) = (Crr * mass_i * 9.81) .* new_v4(n);					%Calculate friction force 
		P_ma(n,:) = (mass_i .* new_v4(n) .* (dvdt_i_4(n)));						%Calculate inertial force 
		total_power(n,:) = P_Cd(n,:) + P_friction(n,:) + P_ma(n,:);				
		pUDDS_i(n,2) =  (total_power(n,:)) ./0.9/0.95;							%Divide total power by battery and drivetrain efficiency 
	end

	for n=1:length(pUDDS_i(:,2))
	    if pUDDS_i(n,2) <0
	       pUDDS_i(n,2) = pUDDS_i(n,2)*0.2; 											%Incorporate Regenerative Braking with end to end 20% efficiency 
	    end
	end

	finalpower = (pUDDS_i(:,2)) + (comp_power(i))/0.95 + (sensor_power(i))/0.95;     	%Add computational and sensor power divided by battery efficiency to total power 

    energy_check(i) = trapz(pUDDS_i(:,1),finalpower(:,1)) * 2.77778e-7;  %kWh			%Integrate power with time to get energy and convert to kWh

    cycles(i) = capacity/energy_check(i);												%Divide battery energy capacity by energy required for one drive cycle of 9.8 miles to get how many cycles can be replicated

    range1(i) = smoothdist*cycles(i);													%Multiply smoothed drive cycle range by number of cycles to get total range 
end

%Return what percentage of monte carlo runs result in a range reduction compared to EV only range in the autonomy without LiDAR case
percentage_less_than_originalrange = (sum(range1<=evrange)/length(range1)) * 100
median(range1)


%Create new empty vectors
x = [];
sensor_power =[];
comp_power=[];
energy_check=[];
cycles=[];
lambda=[];

drag2 = makedist('Uniform','Lower', 15,'Upper',40);				%Uniform distribution for increase in drag from spinning LiDAR between 15% to 40% increase in drag

%Run 2nd monte carlo simulations for composite cycle with LiDAR 
for i=1:10000
	x(i) = random(drag2,1,1);									%sample percentage increase in drag due to LiDAR 
																
	Cd = basecd + ((x(i)/100)*basecd);    						%new drag is original drag + percentage increase above

	lambda(i) = random(es, 1,1);          						%1-smoothing parameter sampled for energy savings

	sensor_power(i) = random(sensor,1,1);						%sample sensor load 
	
	comp_power(i) = 7.1*sensor_power(i) - 63;					%correlate computational load to sensor load 

	avweight = 20;												%weight of all autonomous components 

	mass_i = vehicle_weight + avweight + batteryweight;			%calculate total vehicle mass including battery, car only weight, and autonomous system weight

	%%% run spline function for vehicle drive smoothing for incorporating energy savings 

	cf = fit(new_t(1:1436),new_v(1:1436),'smoothingspline','SmoothingParam',1-lambda(i));
	new_t4 = new_t;								%same time vector as previously 
	v4 = cf(new_t(1:1436));
	v4(v4<0) = 0;								%correct all terms below zero to zero
	new_v4 = v4;								%new smoothed velocity profile 
	a4 = diff(new_v4)./diff(new_t4);			%calculate acceleration by differentiating v and t
	a4_1 = [0;a4];								%correct for acceleration vector length by shifting initial acceleration
	a4_2 = [a4;0];								%correct for acceleration vector length by shifting final acceleration
	dvdt_i_4 = (a4_1 + a4_2) /2;				%true acceleration value is average of both values [this has to be done to improve the time resolution of our drive cycle data]

	smoothdist = trapz(new_t4,new_v4)./1.6e3;		%calculate range of smoothed profile  - should be same as original drive cycle range

	for n=1:length(dvdt_i_4)
		P_Cd(n,:) = ((0.5*1.225*Cd*Area_f) .* (new_v4(n).^3));					%Calculate drag force
		P_friction(n,:) = (Crr * mass_i * 9.81) .* new_v4(n);					%Calculate friction force 
		P_ma(n,:) = (mass_i .* new_v4(n) .* (dvdt_i_4(n)));						%Calculate inertial force 
		total_power(n,:) = P_Cd(n,:) + P_friction(n,:) + P_ma(n,:);				
		pUDDS_i(n,2) =  (total_power(n,:)) ./0.9/0.95;							%Divide total power by battery and drivetrain efficiency 
	end

	for n=1:length(pUDDS_i(:,2))
	    if pUDDS_i(n,2) <0
	       pUDDS_i(n,2) = pUDDS_i(n,2)*0.2; 											%Incorporate Regenerative Braking with end to end 20% efficiency 
	    end
	end

	finalpower = (pUDDS_i(:,2)) + (comp_power(i))/0.95 + (sensor_power(i))/0.95;     	%Add computational and sensor power divided by battery efficiency to total power 

    energy_check(i) = trapz(pUDDS_i(:,1),finalpower(:,1)) * 2.77778e-7;  %kWh			%Integrate power with time to get energy and convert to kWh

    cycles(i) = capacity/energy_check(i);												%Divide battery energy capacity by energy required for one drive cycle of 9.8 miles to get how many cycles can be replicated

    range2(i) = smoothdist*cycles(i);													%Multiply original drive cycle range by number of cycles to get total range
end

%Return what percentage of monte carlo runs result in a range reduction compared to EV only range in the autonomy with LiDAR case
percentage_less_than_originalrange2 = (sum(range2<=evrange)/length(range2)) * 100
median(range2)

figure(1)
histogram(range2, 50)    %plot histogram of composite cycle results with LiDAR
hold on
histogram(range1, 50)    %plot histogram of composite cycle results without LiDAR 
xlim([250 450])


pause

%------------------------------------------------------End of Composite cycle model----------------------------------------------------------


%Create new empty vectors
x = [];
sensor_power =[];
pUDDS_i =[];
comp_power=[];
lambda=[];

city = csvread('udds.csv');     				%Load file for the city driving cycle (EPA UDDS cycle available at: https://www.nrel.gov/transportation/drive-cycle-tool/)

new_t_city = city(1:1373,1);  					%time vector created
new_v_city = city(1:1373,2)*0.44704; 			%velocity vector created in m/s		
pUDDS_city(:,1) = new_t_city;   				%creation of time vector in power array

evrange_city = 390; 							%Range in miles of Tesla Model 3 EV only for a city driving cycle such as the UDDS cycle used here.

%Define distributions for City Monte Carlo Simulations				
es2 = makedist('Uniform','Lower',0.9,'Upper',0.9995);				%distribution for 1-smoothing parameter for energy savings for city driving 	

%Run 3rd monte carlo for city driving simulations with no LiDAR
for i=1:10000
	x(i) = 0;													% percentage increase in drag from no LiDAR / solid state
																
	Cd = basecd + ((x(i)/100)*basecd);    						%new drag is original drag + percentage increase above

	lambda(i) = random(es2, 1,1);          						%1-smoothing parameter sampled for energy savings

	sensor_power(i) = random(sensor,1,1);						%sample sensor load 
	
	comp_power(i) = 7.1*sensor_power(i) - 63;					%correlate computational load to sensor load 

	avweight = 20;												%weight of all autonomous components 

	mass_i = vehicle_weight + avweight + batteryweight;			%calculate total vehicle mass including battery, car only weight, and autonomous system weight

	%%% run spline function for vehicle drive smoothing for incorporating energy savings 

	cf = fit(new_t_city(1:1373),new_v_city(1:1373),'smoothingspline','SmoothingParam',1-lambda(i));
	new_t5 = new_t_city;						%same time vector as previously 
	v5 = cf(new_t_city(1:1373));
	v5(v5<0) = 0;								%correct all terms below zero to zero
	new_v5 = v5;								%new smoothed velocity profile 
	a5 = diff(new_v5)./diff(new_t5);			%calculate acceleration by differentiating v and t
	a5_1 = [0;a5];								%correct for acceleration vector length by shifting initial acceleration
	a5_2 = [a5;0];								%correct for acceleration vector length by shifting final acceleration
	dvdt_i_5 = (a5_1 + a5_2) /2;				%true acceleration value is average of both values [this has to be done to improve the time resolution of our drive cycle data

	smoothdist_city = trapz(new_t5,new_v5)./1.6e3;		%calculate range of smoothed city profile   

	for n=1:length(dvdt_i_5)
		P_Cd(n,:) = ((0.5*1.225*Cd*Area_f) .* (new_v5(n).^3));					%Calculate drag force
		P_friction(n,:) = (Crr * mass_i * 9.81) .* new_v5(n);					%Calculate friction force 
		P_ma(n,:) = (mass_i .* new_v5(n) .* (dvdt_i_5(n)));						%Calculate inertial force 
		total_power(n,:) = P_Cd(n,:) + P_friction(n,:) + P_ma(n,:);				
		pUDDS_city(n,2) =  (total_power(n,:)) ./0.9/0.95;						%Divide total power by battery and drivetrain efficiency 
	end

	for n=1:length(pUDDS_city(:,2))
	    if pUDDS_city(n,2) <0
	       pUDDS_city(n,2) = pUDDS_city(n,2)*0.2; 											%Incorporate Regenerative Braking with end to end 20% efficiency 
	    end
	end

	finalpower = (pUDDS_city(:,2)) + (comp_power(i))/0.95 + (sensor_power(i))/0.95;     	%Add computational and sensor power divided by battery efficiency to total power 

    energy_check3(i) = trapz(pUDDS_city(:,1),finalpower(:,1)) * 2.77778e-7;  %kWh			%Integrate power with time to get energy and convert to kWh

    cycles3(i) = capacity/energy_check3(i);													%Divide battery energy capacity by energy required for one drive cycle to get how many cycles can be replicated

    range3(i) = smoothdist_city * cycles3(i);												%Multiply city smoothed drive cycle range by number of cycles to get total range
end

%Return what percentage of monte carlo runs result in a range reduction compared to EV only range in the autonomy without LiDAR case for city cycle
percentage_less_than_originalrange3 = (sum(range3<=evrange_city)/length(range3)) * 100
median(range3)


%create empty vectors 
x = [];
sensor_power =[];
pUDDS_i =[];
comp_power=[];
lambda=[];
pUDDS_city2(:,1) = new_t_city;   								%creation of time vector in power array


%Run 4th monte carlo simulations with LiDAR for city profile 
for i=1:10000
	x(i) = random(drag2,1,1);									%sample percentage increase in drag due to LiDAR 
																
	Cd = basecd + ((x(i)/100)*basecd);    						%new drag is original drag + percentage increase above

	lambda(i) = random(es2, 1,1);          						%1-smoothing parameter sampled for energy savings for city profile 

	sensor_power(i) = random(sensor,1,1);						%sample sensor load 
	
	comp_power(i) = 7.1*sensor_power(i) - 63;					%correlate computational load to sensor load 

	avweight = 20;												%weight of all autonomous components 

	mass_i = vehicle_weight + avweight + batteryweight;			%calculate total vehicle mass including battery, car only weight, and autonomous system weight

	%%% run spline function for vehicle drive smoothing for incorporating energy savings 

	cf = fit(new_t_city(1:1373),new_v_city(1:1373),'smoothingspline','SmoothingParam',1-lambda(i));
	new_t5 = new_t_city;						%same time vector as previously 
	v5 = cf(new_t_city(1:1373));
	v5(v5<0) = 0;								%correct all terms below zero to zero
	new_v5 = v5;								%new smoothed velocity profile 
	a5 = diff(new_v5)./diff(new_t5);			%calculate acceleration by differentiating v and t
	a5_1 = [0;a5];								%correct for acceleration vector length by shifting initial acceleration
	a5_2 = [a5;0];								%correct for acceleration vector length by shifting final acceleration
	dvdt_i_5 = (a5_1 + a5_2) /2;				%true acceleration value is average of both values [this has to be done to improve the time resolution of our drive cycle data]

	smoothdist_city = trapz(new_t5,new_v5)./1.6e3;		%calculate range of smoothed city profile  

	for n=1:length(dvdt_i_5)
		P_Cd(n,:) = ((0.5*1.225*Cd*Area_f) .* (new_v5(n).^3));					%Calculate drag force
		P_friction(n,:) = (Crr * mass_i * 9.81) .* new_v5(n);					%Calculate friction force 
		P_ma(n,:) = (mass_i .* new_v5(n) .* (dvdt_i_5(n)));						%Calculate inertial force 
		total_power(n,:) = P_Cd(n,:) + P_friction(n,:) + P_ma(n,:);				
		pUDDS_city2(n,2) =  (total_power(n,:)) ./0.9/0.95;						%Divide total power by battery and drivetrain efficiency 
	end

	for n=1:length(pUDDS_city2(:,2))
	    if pUDDS_city2(n,2) <0
	       pUDDS_city2(n,2) = pUDDS_city2(n,2)*0.2; 											%Incorporate Regenerative Braking with end to end 20% efficiency 
	    end
	end

	finalpower = (pUDDS_city2(:,2)) + (comp_power(i))/0.95 + (sensor_power(i))/0.95;     	%Add computational and sensor power divided by battery efficiency to total power 

    energy_check4(i) = trapz(pUDDS_city2(:,1),finalpower(:,1)) * 2.77778e-7;  %kWh			%Integrate power with time to get energy and convert to kWh

    cycles4(i) = capacity/energy_check4(i);													%Divide battery energy capacity by energy required for one drive cycle to get how many cycles can be replicated

    range4(i) = smoothdist_city * cycles4(i);												%Multiply smoothed drive cycle range by number of cycles to get total range
end

%Return what percentage of monte carlo runs result in a range reduction compared to EV only range in the autonomy with LiDAR case for city cycle
percentage_less_than_originalrange4 = (sum(range4<=evrange_city)/length(range4)) * 100
median(range4)

figure(2)
histogram(range4, 50)   %plot city cycle results with LiDAR
hold on
histogram(range3, 50)   %plot city cycle results without LiDAR
xlim([250 450])


%-----------------------------------------------------------End of code-----------------------------------------------------------


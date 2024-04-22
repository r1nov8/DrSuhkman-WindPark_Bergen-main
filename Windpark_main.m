%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main File                                                                     %
% Calls all relevant functions (can be found in folder 01_functions)            %
%   1) Creates data structure of wind park -> generateWP()                      %
%   2) Initialises big matrices -> Initialisation()                             %
%   3) Start computation OR optimisation function ->                            %
%       3.1) For One steady state:                                              %
%           Windparkcomputation()/ Yaw_angle_optimiser()/Layout_optimiser()     %
%       3.2) For whole windrose/ AEP                                            %
%            AEP_Computation()/ AEP_Optimiser()                                 %
%   4) Start computation for graphical output -> GraphicalComputation()         %
%   5) Plot requested graphs -> plots()                                         %
%   6) Delete computational leftovers -> cleanit()                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths / Clear workspace1s
clear
close all
addpath('01_functions','02_inputs','03_results','04_Validationdata/','05_Turbinen/','06_Windrose/');

%%%%%%%%%%%%%%%%%%%%%%%%% Create data structure from input %%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For normal use
WP=generateWP();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Loop over all wind parks
WParks=fieldnames(WP);
for k=1:numel(WParks)
    %No graphical output for AEP Prediction!
    if WP.(WParks{k}).Comp_AEP==true && WP.(WParks{k}).GraphicalOutput==true
    WP.(WParks{k}).GraphicalOutput=false;
    disp('Sorry, no graphical output supported for AEP prediction.')
    end
tic;
t=toc;
if WP.(WParks{k}).Calc==true
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(['Windpark computation in progress: ', WParks{k}])
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
[WP.(WParks{k}).nWorker]=setparpool(WP.(WParks{k}).parallel, WP.(WParks{k}).nWorker); %Start/ Deactivate Parpool

    if WP.(WParks{k}).nWorker==0 % Licence error -> Fallback for Cluster
    WP.(WParks{k}).nWorker=1;
    end

if WP.(WParks{k}).Comp_AEP==false
%% Initialise huge matrices (to prevent RAM overflow)
    [WP.(WParks{k})]=Initialisation(WP.(WParks{k}));

%% %%%%%%%%%%%%%%%%%% Compute one steady state %%%%%%%%%%%%%%%%%%%
%%Computation of wake  effects on turbines %%%%%%%%%
         if WP.(WParks{k}).Berechnen==true
            [WP.(WParks{k})]=Windparkcomputation(WP.(WParks{k}));
        t1=toc;
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp(['Computation time: ' num2str((t1-t)) 's'])

%% %%%%%%%%%%%%%%%%%% Power Optimiser one steady state %%%%%%%%%%%%%%%%%%%
        elseif WP.(WParks{k}).Optimieren==true
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('Starting steady state optimisation...');
    
            if WP.(WParks{k}).Optimiere_Yawwinkel==1
               [WP.(WParks{k})]=Yaw_angle_optimiser(WP.(WParks{k}));
         elseif WP.(WParks{k}).Optimiere_Koordinaten==1
               [WP.(WParks{k})]=Layout_optimiser(WP.(WParks{k}));
            end
    t5=toc;
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(['Optimisation time:' num2str((t5-t)/60) 'min'])

         end

%% %%%%%%%%%%%%%%%%%% Compute farm APP using whole wind rose %%%%%%%%%%%%%%%%%%%
elseif WP.(WParks{k}).Comp_AEP==true %If AEP Is to be computed

    if WP.(WParks{k}).Berechnen==true
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(['AEP computation in progress: ', WParks{k}])
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

    [WP.(WParks{k})]=AEP_Computation(WP.(WParks{k}));

    t1=toc;
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(['Computation time: ' num2str((t1-t)/60) 'min'])
    
    %% %%%%%%%%%%%%%%%%%% Power Optimiser APP %%%%%%%%%%%%%%%%%%%
    elseif WP.(WParks{k}).Optimieren==true

    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('Starting APP optimisation ...');
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    
    [WP.(WParks{k})]=AEP_Optimiser(WP.(WParks{k}));

    t5=toc;
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(['Optimisation time:' num2str((t5-t)/60) 'min'])
    end
end
end

%% %%%%%%%%%%%%%%%%%%%%% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if WP.(WParks{k}).GraphicalOutput==true && WP.(WParks{k}).plot_Geschwindigkeitsfeld || ...
    WP.(WParks{k}).GraphicalOutput==true && WP.(WParks{k}).plot_Turbulenzfeld
t3=toc;
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('Prepare plots');
WP.(WParks{k})=GraphicalComputation(WP.(WParks{k})); %Compute Velocity/ Turbulence field
WP.(WParks{k})=plots(WP.(WParks{k}),k); %Plot as requested
t4=toc;
disp(['Computation time 4 graphical output: ' num2str(t4-t3)]);
elseif WP.(WParks{k}).GraphicalOutput==true && WP.(WParks{k}).plot_Leistungsabfall==true
    WP.(WParks{k})=plots(WP.(WParks{k}),k); %Plot as requested
end

%% Total comp. time
t5=toc;
if WP.(WParks{k}).Berechnen==true
WP.(WParks{k}).T_total_in_sek=(t5-t); %Safe total computation time
else
WP.(WParks{k}).T_total_in_min=(t5-t)/60; %Safe total computation time
end
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(['Total time: ' num2str((t5-t)/60) 'min'])


%% Save results
[WP.(WParks{k})]=cleanit(WP.(WParks{k})); %Delete leftover variables
Windpark=WP.(WParks{k});
save(['03_results/',Windpark.name,'.mat'],'-v7.3','Windpark')
WP=rmfield(WP,WParks{k});
end
clearvars -except WP

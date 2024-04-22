function [WP] = Yaw_angle_optimiser(WP)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function defines optimisation problem for     %
% fmincon -> for yaw optimisation               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Define optimisation function
fun = @(x) Wind_farm_optimisation(x,WP);
A=[];
b=[];
Aeq=[];
beq=[];

%Upper/ Lower Limit
  lowerLim=WP.YawlowerLim;
  upperLim=WP.YawupperLim;

%Parrallel loop for several starting points (for nStart=1 or if
%parallel=false a normal for loop will be conducted
  nStart=WP.nStart;

x0=WP.vecgammaSTART;
Yawwinkel_Optimiert =zeros(nStart,length(lowerLim));
Gesamtleistung_Optimierung =zeros(1,nStart);
if nStart>1
   if WP.nWorker==1
   for k=1:nStart

problem = createOptimProblem('fmincon','objective',fun,'x0',x0(k,:),'Aeq',A,'beq',b,'Aineq',Aeq,'bineq',beq,'lb',lowerLim,...
  'ub',upperLim,'options', optimoptions(@fmincon,'Algorithm',WP.Algorithm,'Display','iter'));

[x,y]= fmincon(problem); %Run minimum seaching function

%Save results for yaw angle and power (for each starting point)
Yawwinkel_Optimiert(k,:)=x;
Gesamtleistung_Optimierung(k)=y; 
    end     
   else
       WP.Algorithm=Algorithm;
        parfor (k=1:nStart,WP.nWorker)

        problem = createOptimProblem('fmincon','objective',fun,'x0',x0(k,:),'Aeq',A,'beq',b,'Aineq',Aeq,'bineq',beq,'lb',lowerLim,...
        'ub',upperLim,'options', optimoptions(@fmincon,'Algorithm',Algorithm,'Display','iter'));

        [x,y]= fmincon(problem); %Run minimum seaching function

        %Save results for yaw angle and power (for each starting point)
        Yawwinkel_Optimiert(k,:)=x;
        Gesamtleistung_Optimierung(k)=y; 
        end
   end
elseif nStart==1
    k=1;
    problem = createOptimProblem('fmincon','objective',fun,'x0',x0(k,:),'Aeq',A,'beq',b,'Aineq',Aeq,'bineq',beq,'lb',lowerLim,...
  'ub',upperLim,'options', optimoptions(@fmincon,'Algorithm',WP.Algorithm,'Display','iter','MaxFunEvals',80000));

[x,y]= fmincon(problem); %Run minimum seaching function
Yawwinkel_Optimiert(k,:)=x;
Gesamtleistung_Optimierung(k)=y; 
end

% Model wind farm with optimised yaw angles
Gesamtleistung_Optimierung=-Gesamtleistung_Optimierung; %Change sign -> optimisation function == minimalisation function
[~,id]=max(Gesamtleistung_Optimierung); %find combination where the predicted power is highest


WP.vecgamma_grad    = Yawwinkel_Optimiert(id,:);
%% Redefine all values which depend on the yaw angle
    %%Excerpt from INPUT file
    WP.vecgamma       = deg2rad(WP.vecgamma_grad);
    WP.vecYaweff_grad = WP.vecgamma_grad-WP.alpha_grad;
    WP.vecYaweff      = deg2rad(WP.vecYaweff_grad);
    %%Excerpt from initialisation fct.
    WP.cosgamma=cos(WP.vecYaweff);
    WP.singamma=sin(WP.vecYaweff);

%% Compute wind farm one last time with optimised data -> For Result file
WP=wind_farm_computation4_opt(WP);

WP.Yawwinkel_Optimierung=Yawwinkel_Optimiert;
WP.Gesamtleistung_Optimierung = Gesamtleistung_Optimierung;


end
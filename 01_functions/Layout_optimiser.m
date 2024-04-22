function [WP] = Layout_optimiser(WP)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function defines optimisation problem for     %
% fmincon -> for layout optimisation            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nStart=WP.nStart; %Number of starting points
%Define optimisation function
fun = @(x) Wind_farm_optimisation(x,WP);
A=[];
b=[];
Aeq=[];
beq=[];

%Upper/ Lower Limit
  lowerLim=WP.XYlowerLim;
  upperLim=WP.XYupperLim;
  nonlcon=@(x) circularboundaries(x); % Define safety circle around each turbine

x0=WP.matSTART;
if nStart>1
 if WP.nWorker==1 %Several Starting points || NO Parpool
        for k=1:nStart
problem = createOptimProblem('fmincon','objective',fun,'x0',x0(:,:,k),'Aeq',A,'beq',b,'Aineq',Aeq,'bineq',beq,'lb',lowerLim,...
  'ub',upperLim,'nonlcon',nonlcon,'options', optimoptions(@fmincon,'Algorithm',WP.Algorithm,'Display','iter'));

[Koordinaten_Optimiert,Poweroutput] = fmincon(problem);
%Safe Optimised data for each starting point in result array
Koordinaten_Optimiert(:,:,k)=Koordinaten_Optimiert;
Gesamtleistung_Optimierung(:,:,k)=Poweroutput;
        end

 else %Several Starting points || WITH Parpool
       WP.Algorithm=Algorithm;
        parfor (k=1:nStart,WP.nWorker)

        problem = createOptimProblem('fmincon','objective',fun,'x0',x0(:,:,k),'Aeq',A,'beq',b,'Aineq',Aeq,'bineq',beq,'lb',lowerLim,...
        'ub',upperLim,'nonlcon',nonlcon,'options', optimoptions(@fmincon,'Algorithm',Algorithm,'Display','iter'));

        [Koordinaten,Poweroutput] = fmincon(problem);
        %Safe Optimised data for each starting point in result array
        Koordinaten_Optimiert(:,:,k)=Koordinaten;
        Gesamtleistung_Optimierung(:,:,k)=Poweroutput;
        end
 end

elseif nStart ==1 %One Sarting point

options = optimoptions('fmincon','Algorithm',WP.Algorithm,'Display','iter','MaxFunctionEvaluations',100000,'OptimalityTolerance',1.0e-3);
[Koordinaten_Optimiert,Gesamtleistung_Optimierung] = fmincon(fun,x0,A,b,Aeq,beq,lowerLim,upperLim,nonlcon,options);

end

WP.Koordinaten_Optimiert=Koordinaten_Optimiert;
WP.Gesamtleistung_Optimierung=-Gesamtleistung_Optimierung; %Change sign -> optimisation function == minimalisation function 
[~,id]=max(WP.Gesamtleistung_Optimierung); %find combination where the predicted power is highest

% % Modell wind farm with optimised data
WP.vecXTurbines     = WP.Koordinaten_Optimiert(1,:,id);
WP.vecYTurbines     = WP.Koordinaten_Optimiert(2,:,id);

%% Redefine all values which depend on the turbines positions
%Excerpt from initialisation function
% Fix all values connected to the turbines coordinates
vecRes = (-WP.D/2:WP.D/WP.RotorRes:WP.D/2)'; %Vector of rotor points
matR_TMP    =repmat(vecRes, [1,WP.nTurbines])/WP.D;
matx_TMP    =zeros(size(matR_TMP));
matR = matx_TMP.*sin(WP.alpha)+matR_TMP.*cos(WP.alpha);
matx = matx_TMP.*cos(WP.alpha)-matR_TMP.*sin(WP.alpha);
XCalcPointsTMP=zeros([numel(vecRes),WP.nTurbines]);
YCalcPointsTMP=zeros([numel(vecRes),WP.nTurbines]);
XCalcPoints= zeros([numel(vecRes),WP.nTurbines,WP.nTurbines]);
YCalcPoints= zeros([numel(vecRes),WP.nTurbines,WP.nTurbines]);
XCalcPointsTMP(:,1:WP.nTurbines)=matx(:,1:WP.nTurbines)+WP.vecXTurbines(1:WP.nTurbines);
YCalcPointsTMP(:,1:WP.nTurbines)=matR(:,1:WP.nTurbines)+WP.vecYTurbines(1:WP.nTurbines);
for i2=1:WP.nTurbines
    XCalcPoints(:,:,i2)=XCalcPointsTMP-WP.vecXTurbines(i2); %Pull evaluation plane 0.5D infront of the turbine
    YCalcPoints(:,:,i2)=YCalcPointsTMP-WP.vecYTurbines(i2); 
    WP.XCalcPoints(:,:,i2)=(XCalcPoints(:,:,i2).*cos(-WP.alpha)-YCalcPoints(:,:,i2).*sin(-WP.alpha))-0.5; %Transform coordinates to make the hub of each ind.
    WP.YCalcPoints(:,:,i2)=XCalcPoints(:,:,i2).*sin(-WP.alpha)+YCalcPoints(:,:,i2).*cos(-WP.alpha); %turbine 0/0 point
end

WP.matU_Wake=zeros(size(WP.XCalcPoints));
WP.deltaI_Rotor=zeros(size(WP.XCalcPoints));
WP.tmpmat=zeros(size(WP.deltaI_Rotor));
WP.tmpsum=zeros([numel(vecRes),WP.nTurbines]);

%For transverse velocity (Secondary steering)
WP.YCoordinates_Wakecenter=zeros(WP.nTurbines,numel(WP.XCalcPoints(1,:,1)),WP.nTurbines);
if WP.Deflection_Superposition==true
    for i=1:WP.nTurbines
YCoordinate_other_Turbines=WP.YRotorCalcpoints(WP.RotorRes/2+1,1:WP.nTurbines,i)';
WP.YCoordinates_Wakecenter(:,:,i)=repmat(YCoordinate_other_Turbines,1,numel(WP.XCalcPoints(1,:,1))).*WP.D;
    end
WP.v_transverse=zeros(size(WP.YCoordinates_Wakecenter));
else  %For Ishihara function to work
WP.v_transverse=[];
WP.YCoordinates_Wakecenter=[];
end
%% Initiate variables for global convection velocity (Uc)
if WP.momCons_superpos==true
    for i=1:WP.nTurbines
x_Uc(1,:,i) = WP.XCalcPoints(1,:,i); %Resolution in X direction
y_Uc(1,:,i) = linspace(min(WP.YCalcPoints(:,:,i),[],'all')-5,max(WP.YCalcPoints(:,:,i),[],'all')+5,WP.number_Uc_evaluation); %Resolution in Y direction  
    end
 y_Uc=reshape(y_Uc,[WP.number_Uc_evaluation,1,WP.nTurbines]);
 WP.x_Uc_global=repmat(x_Uc,[WP.number_Uc_evaluation,1,1]);
 WP.y_Uc_global=repmat(y_Uc,[1,WP.nTurbines,1]);
% %For transverse velocity (Secondary steering)
WP.YCoordinates_Wakecenter4convection=zeros(WP.nTurbines,numel(WP.x_Uc_global(1,:,1)),WP.nTurbines);
if WP.Deflection_Superposition==true
    for i=1:WP.nTurbines
        YCoordinate_other_Turbines=WP.YRotorCalcpoints(WP.RotorRes/2+1,1:WP.nTurbines,i)';
        WP.YCoordinates_Wakecenter4convection(:,:,i)=repmat(YCoordinate_other_Turbines,1,numel(WP.x_Uc_global(1,:,1))).*WP.D;
    end
WP.v_transverse4convection=zeros(size(WP.YCoordinates_Wakecenter4convection));
else
WP.v_transverse4convection=[];    
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Compute wind farm one last time with optimised data -> For Result file
WP=wind_farm_computation4_opt(WP);


end
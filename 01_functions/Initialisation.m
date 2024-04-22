function [WP] = Initialisation(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Initialisiation   %%%%%%%%%%%%
%%%%% of huge matrices/ %%%%%%%%%%%%
%%%%% variables         %%%%%%%%%%%% 
%%%%% To prevent RAM    %%%%%%%%%%%%
%%%%% overflow          %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Variables for lokal wake calculation
WP.cosgamma=cos(WP.vecYaweff);
WP.singamma=sin(WP.vecYaweff);

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
%% Safe computation coordinates in result struct ->
% to distinguish in result struct between points for actual modelling 
% and points for graphical output
WP.XRotorCalcpoints=WP.XCalcPoints;
WP.YRotorCalcpoints=WP.YCalcPoints;

%% Initialise big arrays
%For Wake computation
WP.matU_Wake=zeros(size(WP.XCalcPoints));
WP.deltaI_Rotor=zeros(size(WP.XCalcPoints));
%For Superposition
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WP.sigma = 100; %Initialise termination criterion
end

    



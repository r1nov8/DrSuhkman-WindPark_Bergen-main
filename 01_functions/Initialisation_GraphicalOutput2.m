function [WP] = Initialisation_GraphicalOutput2(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Initialisiation   %%%%%%%%%%%%
%%%%% of huge matrices/ %%%%%%%%%%%%
%%%%% variables         %%%%%%%%%%%% 
%%%%% To prevent RAM    %%%%%%%%%%%%
%%%%% overflow          %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% THIS FUNCTION IS     %%%%%%%%%%
%%%% IS FOR THE GRAPHICAL %%%%%%%%%%
%%%% OUTPUT               %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Variables for lokal wake calculation
WP.cosgamma=cos(WP.vecYaweff);
WP.singamma=sin(WP.vecYaweff);

%Find transposed to winddirection turbine coordinates
transp_vecXTurbines=WP.vecXTurbines.*cos(-WP.alpha)-WP.vecYTurbines.*sin(-WP.alpha);
transp_vecYTurbines=WP.vecXTurbines.*sin(-WP.alpha)+WP.vecYTurbines.*cos(-WP.alpha); %turbine 0/0 point
%Find vector of computation points according to max/min turbine coordinates
%+ user preset offset
WP.xglobal=min(transp_vecXTurbines)+WP.Xoffset(1):0.1:max(transp_vecXTurbines)+WP.Xoffset(2);
WP.yglobal=(min(transp_vecYTurbines)+WP.Yoffset(1)):0.1:(max(transp_vecYTurbines)+WP.Yoffset(2));
%Create XCalcPoints and YCalcPoints matrix
WP.XCalcPoints=zeros(numel(WP.yglobal),numel(WP.xglobal),WP.nTurbines);
WP.YCalcPoints=zeros(numel(WP.yglobal),numel(WP.xglobal),WP.nTurbines);
[XCalcPointsTMP,YCalcPointsTMP]=meshgrid(WP.xglobal,WP.yglobal);
%Create 3D Matrix for individual computation (x *y * nTurbines)
for i=1:WP.nTurbines
    WP.XCalcPoints(:,:,i)=XCalcPointsTMP-transp_vecXTurbines(i);
    WP.YCalcPoints(:,:,i)=YCalcPointsTMP-transp_vecYTurbines(i);
%     transp_vecXTurbines(:,:,i)=transp_vecXTurbines(:,:,1)-transp_vecXTurbines(1,i,1);
%     transp_vecYTurbines(:,:,i)=transp_vecYTurbines(:,:,1)-transp_vecYTurbines(1,i,1);
end
WP.transp_vecXTurbines=transp_vecXTurbines;
WP.transp_vecYTurbines=transp_vecYTurbines;
% [XCalcPointsTMP,YCalcPointsTMP]=meshgrid(WP.xglobal,WP.yglobal);
% XCalcPoints= zeros([size(XCalcPointsTMP),WP.nTurbines]);
% YCalcPoints= zeros([size(XCalcPointsTMP),WP.nTurbines]);
% WP.XCalcPoints=zeros(size(YCalcPoints)); %Overwrite old variable
% WP.YCalcPoints=zeros(size(YCalcPoints)); %Overwrite old variable
% for i2=1:WP.nTurbines
%     XCalcPoints(:,:,i2)=XCalcPointsTMP-WP.vecXTurbines(i2); 
%     YCalcPoints(:,:,i2)=YCalcPointsTMP-WP.vecYTurbines(i2); 
%     WP.XCalcPoints(:,:,i2)=XCalcPoints(:,:,i2).*cos(-WP.alpha)-YCalcPoints(:,:,i2).*sin(-WP.alpha); %Transform coordinates to make the hub of each ind.
%     WP.YCalcPoints(:,:,i2)=XCalcPoints(:,:,i2).*sin(-WP.alpha)+YCalcPoints(:,:,i2).*cos(-WP.alpha); %turbine 0/0 point
% end

WP.matU_Wake=zeros(size(WP.XCalcPoints));
WP.deltaI_Rotor=zeros(size(WP.XCalcPoints));
WP.C_Windpark=WP.matU_Wake(:,:,1);
WP.tmpmat=zeros(size(WP.deltaI_Rotor));
WP.tmpsum=zeros(size(WP.matU_Wake(:,:,1)));
WP.YCoordinates_Wakecenter=zeros(WP.nTurbines,numel(WP.XCalcPoints(1,:,1)),WP.nTurbines);
%% If secondary steering is computed
if WP.Deflection_Superposition==true
    for i=1:WP.nTurbines
YCoordinate_other_Turbines=WP.YRotorCalcpoints(WP.RotorRes/2+1,1:WP.nTurbines,i)';
WP.YCoordinates_Wakecenter(:,:,i)=repmat(YCoordinate_other_Turbines,1,numel(WP.XCalcPoints(1,:,1))).*WP.D;
    end
WP.v_transverse=zeros(size(WP.YCoordinates_Wakecenter));
end

% % Initiate variables for global convection velocity (Uc)
% if WP.momCons_superpos==true
%     for i=1:WP.nTurbines
% x_Uc(1,:,i) = WP.XCalcPoints(1,:,i); %Resolution in X direction
% y_Uc(1,:,i) = linspace(min(WP.YCalcPoints(:,:,i),[],'all')-5,max(WP.YCalcPoints(:,:,i),[],'all')+5,WP.number_Uc_evaluation); %Resolution in Y direction  
%     end
%  y_Uc=reshape(y_Uc,[WP.number_Uc_evaluation,1,WP.nTurbines]);
%  WP.x_Uc_global=repmat(x_Uc,[WP.number_Uc_evaluation,1,1]);
%  WP.y_Uc_global=repmat(y_Uc,[1,numel(WP.XCalcPoints(1,:,1)),1]);
% % %For transverse velocity (Secondary steering) 
% WP.YCoordinates_Wakecenter4convection=zeros(WP.nTurbines,numel(WP.x_Uc_global(1,:,1)),WP.nTurbines);
% if WP.Deflection_Superposition==true
%     for i=1:WP.nTurbines
%         YCoordinate_other_Turbines=WP.YRotorCalcpoints(WP.RotorRes/2+1,1:WP.nTurbines,i)';
%         WP.YCoordinates_Wakecenter4convection(:,:,i)=repmat(YCoordinate_other_Turbines,1,numel(WP.x_Uc_global(1,:,1))).*WP.D;
%     end
% WP.v_transverse4convection=zeros(size(WP.YCoordinates_Wakecenter4convection));
% else
% WP.v_transverse4convection=[];    
% end
% end
% % if WP.momCons_superpos==true
% % x_Uc = WP.XCalcPoints(1,:,1); %Resolution in X direction
% % y_Uc = linspace(min(WP.vecYTurbines)-5,max(WP.vecYTurbines)+5,WP.number_Uc_evaluation); %Resolution in Y direction
% % [XCalcPointsTMP,YCalcPointsTMP]=meshgrid(x_Uc,y_Uc);
% % XCalcPoints= zeros([size(XCalcPointsTMP),WP.nTurbines]);
% % YCalcPoints= zeros([size(XCalcPointsTMP),WP.nTurbines]);
% % WP.x_Uc_global=zeros(size(YCalcPoints)); %Initialise arrays for coordinates of global convection vel. (Uc)
% % WP.y_Uc_global=zeros(size(YCalcPoints)); %
% % for i2=1:WP.nTurbines
% %     XCalcPoints(:,:,i2)=XCalcPointsTMP-WP.vecXTurbines(i2); 
% %     YCalcPoints(:,:,i2)=YCalcPointsTMP-WP.vecYTurbines(i2); 
% %     WP.x_Uc_global(:,:,i2)=XCalcPoints(:,:,i2).*cos(-WP.alpha)-YCalcPoints(:,:,i2).*sin(-WP.alpha); %Transform coordinates to make the hub of each ind.
% %     WP.y_Uc_global(:,:,i2)=XCalcPoints(:,:,i2).*sin(-WP.alpha)+YCalcPoints(:,:,i2).*cos(-WP.alpha); %turbine 0/0 point
% % end
% % %For transverse velocity (Secondary steering)
% % WP.YCoordinates_Wakecenter4convection=zeros(WP.nTurbines,numel(WP.x_Uc_global(1,:,1)),WP.nTurbines);
% % if WP.Deflection_Superposition==true
% %     for i=1:WP.nTurbines
% %         YCoordinate_other_Turbines=WP.YRotorCalcpoints(WP.RotorRes/2+1,1:WP.nTurbines,i)';
% %         WP.YCoordinates_Wakecenter4convection(:,:,i)=repmat(YCoordinate_other_Turbines,1,numel(WP.x_Uc_global(1,:,1))).*WP.D;
% %     end
% % WP.v_transverse4convection=zeros(size(WP.YCoordinates_Wakecenter4convection));
% % end
% % end
end
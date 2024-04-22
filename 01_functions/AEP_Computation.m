function [WP] = AEP_Computation(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute AEP of given wind farm          %
% Using given wind rose                   %
% Returns:                                %
%   - the predicted power for             %
%     each combination of wind direction, %
%     speed and atmospheric stability     %
%   - summed up weighted AEP of the farm  %
%   - AEP of each single turbine          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if WP.parallel==false
    for i=1:numel(WP.alpha_Windrose) %Iterate over given Winddirections
        if WP.Optimieren==false
            disp(['Progress: ', num2str(100*(i-1)/numel(WP.alpha_Windrose)), '%'])
        end
    %% Correct input values
    WP.alpha_grad=WP.alpha_Windrose(i);
    WP.alpha=deg2rad(WP.alpha_grad);
    WP.vecgamma_grad   = WP.alpha_grad+zeros(1,WP.nTurbines);
    WP.vecgamma        = WP.alpha+zeros(1,WP.nTurbines);
    WP.vecYaweff_grad = WP.vecgamma_grad-WP.alpha_grad;
    WP.vecYaweff      = deg2rad(WP.vecYaweff_grad);
    %% Initialise huge matrices
    [WP]=Initialisation(WP);
        for ii=1:numel(WP.U_Windrose(1,:)) %iterate over given wind speeds
            for iii=1:numel(WP.LengthScale)%iterate over given length scales (for different atmospheric stabilities)
                 WP.C_Wind      = WP.U_Windrose(i,ii);
                 WP.lambda      = (2.*pi.*(WP.rpm./60).*(WP.D./2))./WP.C_Wind;
                 WP.vecUTurbinesOLD = zeros(1,WP.nTurbines);
                 WP.vecUTurbines    = WP.C_Wind+zeros(1,WP.nTurbines);%Inflow speed
                 WP.vecITurbines    =WP.Ia+zeros(1,WP.nTurbines); %Inflow turbulence
                 WP.Lambda      =WP.LengthScale(iii);
                 WP.sigma       =100;
                 WP.P0    = WP.density*pi/4*WP.D^2*WP.C_Wind^3/2;
                if WP.VestasV80==true
                    WP.vecCT_Turbines=interp1(WP.vecCTinput(:,1),WP.vecCTinput(:,2),WP.vecUTurbines); %Initialisiere CT für Turbinen
                    WP.vecP_Turbines=interp1(WP.vecPinput(:,1),WP.vecPinput(:,2),WP.vecUTurbines); %Initialisiere P für Turbinen
                elseif WP.FIVEMWReference==true
                        %CT/ CP Vektor für alle Turbinen
                    WP.vecCT_Turbines=interp2(WP.vecpitchinput, WP.veclambdainput, WP.vecCTinput, WP.vecpitch, WP.lambda, 'spline'); %Initialisiere CT für Turbinen
                    WP.vecCP_Turbines=interp2(WP.vecpitchinput, WP.veclambdainput, WP.vecCPinput, WP.vecpitch, WP.lambda, 'spline'); %Initialisiere CP für Turbinen   
                WP.vecpitch_grad=WP.pitchcontrol(WP.vecUTurbines);% Control Pitch
                end
%% %%%%%%%%%%%%%%%%%% Compute %%%%%%%%%%%%%%%%%%%
        [WP]=Windparkcomputation(WP);
        WP.AEP_AllPowers(i,ii,iii)=WP.PtotalWP;
        if WP.Berechnen==true
        WP.Graphmaterial(:,:,i)=WP.vecP_Turbines;
        end
            end
        end
    end

%% If possible modell wind directions in parallel
elseif WP.parallel==true
TMPCell=cell(1,numel(WP.alpha_Windrose));
ParforEnd=numel(WP.alpha_Windrose);
for I=1:numel(WP.alpha_Windrose)
TMPCell{I} = WP;
end
    parfor (i=1:ParforEnd,WP.nWorker) %Iterate over given Winddirections
        WP=TMPCell{i};
        if WP.Optimieren==false
            disp(['Progress: ', num2str(100*(i-1)/numel(WP.alpha_Windrose)), '%'])
        end
    %% Correct input values
    WP.alpha_grad=WP.alpha_Windrose(i);
    WP.alpha=deg2rad(WP.alpha_grad);
    WP.vecgamma_grad   = WP.alpha_grad+zeros(1,WP.nTurbines);
    WP.vecgamma        = WP.alpha+zeros(1,WP.nTurbines);
    WP.vecYaweff_grad = WP.vecgamma_grad-WP.alpha_grad;
    WP.vecYaweff      = deg2rad(WP.vecYaweff_grad);
            WP.C_Wind      = WP.U_Windrose(i);
            WP.lambda      = (2.*pi.*(WP.rpm./60).*(WP.D./2))./WP.C_Wind;
            WP.vecUTurbinesOLD = zeros(1,WP.nTurbines);
            WP.vecUTurbines    = WP.C_Wind+zeros(1,WP.nTurbines);%Inflow speed
            WP.vecITurbines    =WP.Ia+zeros(1,WP.nTurbines); %Inflow turbulence
            WP.Lambda      =WP.LengthScale;
            WP.sigma       =100;
            WP.P0    = WP.density*pi/4*WP.D^2*WP.C_Wind^3/2;
    %% Initialise huge matrices
    [WP]=Initialisation(WP);
%% %%%%%%%%%%%%%%%%%% Compute %%%%%%%%%%%%%%%%%%%
        [WP]=Windparkcomputation(WP); %Compute each state 
        AEP_AllPowers(i)=WP.PtotalWP; %Save each predicted power output
        if WP.Berechnen==true
        Graphmaterial(:,:,i)=WP.vecP_Turbines;
        end
    end
    WP=TMPCell{1};
    WP.AEP_AllPowers=AEP_AllPowers';
    WP.Graphmaterial=Graphmaterial;
end
    %% Now Compute AEP with Given Probabilities and computed Powers
    % Sum up AEP with given Probabilities
    WP.AEP=sum((WP.AEP_AllPowers.*WP.Prob_Stability./100),3);
    WP.AEP=sum((WP.AEP.*WP.Prob_U./100),2);
    WP.AEP=sum((WP.AEP.*WP.Prob_alpha'./100));
    if WP.Berechnen==true
    % Compute ind. Turbine AEP
     for ii=1:72
        WP.GraphmaterialAEP(:,:,ii)=WP.Graphmaterial(:,:,ii).*WP.Prob_alpha(ii)./100;
     end
    WP.GraphmaterialAEP=sum(WP.GraphmaterialAEP,3);
    end
    %% Apply to operation hours
    WP.AEPinGWH=WP.AEP.*8760/10^6;
    if WP.Optimieren==false
            disp(['Progress: ', num2str(100), '%'])
    end
    
end
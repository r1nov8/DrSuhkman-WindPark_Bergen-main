function [WP ,sigma] = superposition(WP, i)
%% %%%%%%%%%%%%%%%%%%%%%% Superposition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Superposition function. Uses either:                                  %
%    1) Linear Rotor based superposition by Niayifar & Porté-Agel (2016) % 
%    2) Momentum conserving superposition by Zong & Porté-Agel (2020)    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Superpose individually computed wakeeffects                         %
%  - Compute termination criterion                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WP.vecUTurbinesOLD=WP.vecUTurbines; % Safe old inflow velocities

%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Windspeed       %%%
%%%%%%%%%%%%%%%%%%%%%%%%
if WP.momCons_superpos==true
    %%First determine global Uc
    if i==1 %During first iteration take maximum individual uc as values for UC
        Uc=max(WP.u_convect,[],[1,3]);
        Uc(Uc==0)=WP.C_Wind;
        WP.Uc=WP.C_Wind.*zeros(size(Uc)); %Initialise 
        WP.matUc=zeros(size(WP.VelocityDef4Uc));
    else %During all other operations follow equations from paper/report
        U_deficit=WP.C_Wind-WP.matUc; %Compute wake velocity from velocity deficit
        Uc=sum(WP.matUc.*U_deficit,1)./sum(U_deficit,1);
        Uc(isnan(Uc))=WP.C_Wind; %Nanfilter    
    end
  %% Now compute actual velocity using uc & Uc
  tmpfrac=(WP.u_convect./Uc);
  WP.vecUTurbines_rad=tmpfrac.*WP.matU_Wake;
  WP.vecUTurbines_rad=WP.C_Wind-sum(WP.vecUTurbines_rad,3); %Sum up terms
  WP.vecUTurbines = mean(WP.vecUTurbines_rad); %Mean value of windspeed in rotor plane

  %% Also compute velocities for global Uc in next iteration
     WP.matUc=tmpfrac.*WP.VelocityDef4Uc;
     WP.matUc=WP.C_Wind-sum(WP.matUc,3); %Sum up terms
else
  %% If no momentum conservation -> Use rotorbased linear sum
WP.tmpsum=sum(WP.matU_Wake,3); % Sum up all the speed deficits
WP.vecUTurbines_rad = WP.C_Wind-WP.tmpsum; % Substract from ambient wind speed
WP.vecUTurbines = mean(WP.vecUTurbines_rad);
end

%%%%%%%%%%%%%%%%%%
%%%% Turbulence %%%
%%%%%%%%%%%%%%%%%%
WP.tmpmat = 0.*WP.tmpmat; % Temporary matrix
WP.tmpmat = (WP.deltaI_Rotor).^2;   % All turbulences ^2 for quadr. summation
WP.tmpsum=sum(WP.tmpmat,3);                 %Sum up all induced turbulences
WP.vecITurbines_rad =sqrt(WP.Ia.^2+WP.tmpsum); %Turbulence of each turbine w.r.t. inflow turbulence
WP.vecITurbines = mean(WP.vecITurbines_rad);

%% Calculate termination criterion
if WP.momCons_superpos==true
% [sigma2] = max(abs(WP.Uc - Uc),[],'all');
% display(num2str(sigma2));
[sigma] = max(abs(WP.vecUTurbines - WP.vecUTurbinesOLD),[],'all');
% disp(['Sigma: ', num2str(sigma)]);
WP.Uc=Uc; %Store value for next iteration
else
[sigma] = max(abs(WP.vecUTurbines - WP.vecUTurbinesOLD),[],'all');
end

%% Reevaluate Thrust and Power according to new inflow windspeed
if WP.FIVEMWReference==1
WP.vecpitch_grad=WP.pitchcontrol(WP.vecUTurbines);% Control Pitch
WP.vecpitch=deg2rad(WP.vecpitch_grad);
WP.vecrpm=WP.rpmcontrol(WP.vecUTurbines);% Control RPM
WP.veclambda        = 2.*pi.*(WP.vecrpm/60)*(WP.D/2)./WP.vecUTurbines; % Reevaluation of TSR acc. to new inflow/rpm dataNeuberechnung Schnelllaufzahl (Nach geänderter Anströmgeschwindigkeit und Drehzahl)
WP.vecP_Turbines=[];
%Interpolate CT & CP for new conditions (depend on TSR and Pitch angle)
WP.vecCT_Turbines=interp2(WP.vecpitchinput, WP.veclambdainput, WP.vecCTinput, WP.vecpitch, WP.veclambda, 'spline'); %Initialisiere CT für Turbinen
WP.vecCP_Turbines=interp2(WP.vecpitchinput, WP.veclambdainput, WP.vecCPinput, WP.vecpitch, WP.veclambda, 'spline'); %Initialisiere CP für Turbinen
elseif WP.VestasV80==1
    WP.vecpitch=[];
    WP.vecrpm=[];
    WP.veclambda=[];
    WP.vecCP_Turbines=[];
    WP.vecCT_Turbines=interp1(WP.vecCTinput(:,1),WP.vecCTinput(:,2),WP.vecUTurbines); %Initialisiere CT für Turbinen
    WP.vecP_Turbines=interp1(WP.vecPinput(:,1),WP.vecPinput(:,2),WP.vecUTurbines); %Initialisiere P für Turbinen
end
end
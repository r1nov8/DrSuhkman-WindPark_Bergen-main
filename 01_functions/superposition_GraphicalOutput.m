function [C_Windpark, I_Windpark, Uc_old, sigma] = superposition_GraphicalOutput(WP, iteration)
%% Superpose individually computed wakeeffects
%% SUPERPOSITION FOR GRAPHICAL OUTPUT %%%
%%% uses: Linear Rotor based superposition by Niayifar & Porté-Agel (2016)
%% %%%%%%%%%%%%%%%%%%%%%% Superposition %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Windspeed       %%%
%%%%%%%%%%%%%%%%%%%%%%%%
if WP.momCons_superpos==true 
%% If momentum conserving superposition called
    if iteration==1 %During first iteration take maximum individual uc as values for UC
        Uc=max(WP.u_convect,[],[1,3]);
        Uc(Uc==0)=WP.C_Wind;
        WP.Uc=WP.C_Wind.*zeros(size(Uc)); %Initialise 
    else %During all other operations follow equations from paper/report
        U_deficit=WP.C_Wind-WP.C_Windpark; %Compute wake velocity from velocity deficit
        Uc=sum(WP.C_Windpark.*U_deficit,1)./sum(U_deficit,1);
        Uc(isnan(Uc))=WP.C_Wind; %Nanfilter    
    end
  %% Now compute actual velocity using uc & Uc
  for i=1:WP.nTurbines %Compute term to sum for each turbine
        tmpfrac=(WP.u_convect(:,:,i)./Uc);
        C_Windpark(:,:,i)=(tmpfrac.*WP.matU_Wake(:,:,i));
  end
    C_Windpark=WP.C_Wind-sum(C_Windpark,3); %Sum up terms
    %Compute terimation criterion
    [sigma] = max(abs(WP.Uc - Uc),[],'all');
%     disp(['Sigma: ', num2str(sigma)]);
    Uc_old=Uc; %Store value for next iteration
else 
%% If linear rotor sum called    
WP.tmpsum=sum(WP.matU_Wake,3); % Sum up all the speed deficits
C_Windpark = WP.C_Wind-WP.tmpsum; % Substract from ambient wind speed
sigma=0;
Uc_old=[];
end

if iteration==1 %Compute only on first iteration
%%%%%%%%%%%%%%%%%%
%%%% Turbulence %%%
%%%%%%%%%%%%%%%%%%
WP.tmpmat = 0.*WP.tmpmat; % Temporary matrix
WP.tmpmat = (WP.deltaI_Rotor).^2;   % All turbulences ^2 for quadr. summation
WP.tmpsum=sum(WP.tmpmat,3);                 %Sum up all induced turbulences
I_Windpark =sqrt(WP.Ia.^2+WP.tmpsum); %Turbulence of each turbine w.r.t. inflow turbulence
else
I_Windpark=WP.I_Windpark;    
end 
end
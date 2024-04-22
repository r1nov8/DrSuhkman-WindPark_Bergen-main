function [U_Wakexr] = JGWakemodel(WP)

R=WP.D/2; %Rotorradius+
vecUTurbines=WP.vecUTurbines.*cos(WP.vecYaweff);

%%%%%% Vektorisieren der Inputgrößen %%%%%%

matCT =repmat(WP.vecCT_Turbines,[numel(WP.vec_r), 1, numel(WP.x_D)]);
matUTurbines = repmat(vecUTurbines, [numel(WP.vec_r), 1, numel(WP.x_D)]);
matr  =repmat(WP.vec_r',[1,WP.nTurbines,numel(WP.x_D)]);
matx_D=zeros(numel(WP.vec_r),WP.nTurbines,numel(WP.x_D));
for i = 1:numel(WP.x_D)
  matx_D(:,:,i) = WP.x_D(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = 0.5 *(1-sqrt(1-matCT)); % Axialer Induktionsfaktor
%% %%%% Turbulenz Berechen%%%%

%Crespo & Hernandez Rotorturbulenz
I_CH = 0.73.*(a.^0.8325)*(WP.Ia.^0.0325).*(matx_D.^-0.32); %Durch Rotor hinzugefügte Turb.
I_Wake = sqrt(WP.Ia.^2 + (I_CH).^2); %Gesamtturbulenz des Nachlaufs

k_Wake = WP.k * (I_Wake/WP.Ia); %Wake decay constant

%% %%%% Geschwindigkeit Centerline nach Jensen 

Uc = 1-((1-sqrt(1-matCT))./(1+2*k_Wake.*matx_D).^2);


%% Geschwindigkeit im Nachlauf an der Stelle (x,r) -> 3D Matrix (r, nTurbine, x) (Radiale Position, Turbine, Axiale Position)

U_Wakexr=matUTurbines.*(1-(1-Uc).*(5.16/sqrt(2*pi)).*exp((-3.3282.*((matr).^2))./(k_Wake.*(matx_D*WP.D)+R).^2));


end


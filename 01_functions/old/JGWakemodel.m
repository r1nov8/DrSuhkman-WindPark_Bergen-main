function [U_Wakexr] = JGWakemodel(WP)

R=WP.D/2; %Rotorradius

%Bestimmen des aktuellen Schubewertes - abh. von Yawwinkel (Normalanteil
%des Windes auf Rotorebene)

%%%%%% Vektorisieren der Inputgrößen %%%%%%
[matx_D, matr, matUTurbines] =meshgrid(WP.x_D, WP.vec_r, WP.vecUTurbines);
matCT =zeros(numel(WP.vec_r),numel(WP.x_D),WP.nTurbines);
for i = 1:WP.nTurbines
  matCT(:,:,i) = WP.vecCT_Turbines(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = 0.5 *(1-sqrt(1-matCT)); % Axialer Induktionsfaktor
%% %%%% Turbulenz Berechen%%%%

%Crespo & Hernandez Rotorturbulenz
I_CH = 0.73*(a.^0.8325)*(WP.Ia^0.0325).*(matx_D.^-0.32); %Durch Rotor hinzugefügte Turb.
I_Wake = sqrt(WP.Ia.^2 + (I_CH).^2); %Gesamtturbulenz des Nachlaufs
WP.k   = 0.5*I_Wake;
k_Wake = WP.k .* (I_Wake/WP.Ia); %Wake decay constant

%% %%%% Geschwindigkeit Centerline nach Jensen 

Uc = 1-(1-sqrt(1-matCT))./(1+2*k_Wake.*matx_D).^2;


%% Geschwindigkeit im Nachlauf an der Stelle (x,r) -> 3D Matrix (r, nTurbine, x) (Radiale Position, Turbine, Axiale Position)

U_Wakexr=matUTurbines.*(1-(1-Uc).*(5.16/sqrt(2*pi)).*exp(-3.3282.*(matr.^2)./(k_Wake.*matx_D*WP.D+R).^2));


end


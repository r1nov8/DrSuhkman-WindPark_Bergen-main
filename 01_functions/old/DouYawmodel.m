function [U_Wakexr] = DouYawmodel(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alte Implementierung des Wakemodells mit Yawwinkel nach DOU et al. %
% Für Benutzung muss der Main Code geändert werden                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% AUS WP DATEN 3 DIMENSIONALE MATRIZEN MACHEN! (n_T, r, x)
vecUTurbines=WP.vecUTurbines;

%% Konstanten %% -> Siehe Literatur nach DOU
 delta_skew	= 0.607;
 zeta       = 0.75;
 p1         = 5;
 p2         = 4.63;
 %k_expansion= 0.3937 * WP.Ia + 0.0037;
 k_expansion= 0.023;

%%%%%% Vektorisieren der Inputgrößen %%%%%%
[matx_D, matr, matUTurbines] =meshgrid(WP.x_D, WP.vec_r, vecUTurbines);
matgamma = zeros(numel(WP.vec_r),numel(WP.x_D),WP.nTurbines);
matCT =zeros(numel(WP.vec_r),numel(WP.x_D),WP.nTurbines);
for i1 = 1:WP.nTurbines
  matCT(:,:,i1) = WP.vecCT_Turbines(i1);
  matgamma(:,:,i1) = WP.vecYaweff(i1);
end

%Modellkorrektur für negative Yawwinkel (alle Turbinen werden positiv gerechnet, jedoch am Ende
%gespiegelt)
negativeyaw = WP.vecYaweff<0;
matgamma = abs(matgamma);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Turbulenz Berechen%%%%
% 
% %Crespo & Hernandez Rotorturbulenz
% I_CH = 0.73*a.^0.8325*(WP.Ia.^0.0325)*x_D.^-0.32; %Durch Rotor hinzugefügte Turb.
% I_Wake = sqrt(WP.Ia.^2 + (I_CH).^2); %Gesamtturbulenz des Nachlaufs
% 
% k_Wake = WP.k * (I_Wake/WP.Ia); %Wake decay constant
 
%% Zwischenergebnisse Skew %%
CT_Yaw  = cos(matgamma).^2.* matCT;
delta   = delta_skew .* matCT;
beta    = (1+sqrt(1-CT_Yaw.*cos(matgamma)))./(2*sqrt(1-CT_Yaw.*cos(matgamma)));
sig   = (k_expansion.*(matx_D.*WP.D)./(WP.D*cos(matgamma))) + (sqrt(beta)/5);
alpha   = p1.*(matCT).^p2.*tan(matgamma);

my      = alpha./sqrt(1+alpha.^2);
phi     = (0.5*(4-pi)*(my*sqrt(2/pi)).^3)./(1-2*my.^2/pi).^(3/2);
m       = sqrt(2.*my./pi)-0.5.*phi.*sqrt(1-(2.*my.^2)/pi)-0.5.*sign(alpha).*exp(-2.*pi./abs(alpha));
Yoffset = WP.D.*(delta.*(matCT.*sin(matgamma)).^(zeta).*(cos(matgamma).^(2*zeta)).*sqrt(matx_D) + (WP.drt./WP.D).*sin(matgamma));
C1      = (matr-Yoffset+sig.*m.*WP.D.*cos(matgamma))./(WP.D.*cos(matgamma));


%% Geschwindigkeit im Nachlauf an der Stelle (x,r)
%%Integralparameter für Modell
O = alpha.*C1./sig;
% U = -Inf+(zeros(numel(WP.vec_r),numel(WP.x_D),WP.nTurbines));
% fun = @(t) (sqrt(2/pi)*exp(-t.^2/2));
% funi= @(U,O)integral(fun,U,O);

% Nachlaufberechnung
% U_Wakexr = matUTurbines.*(1-(1-sqrt(1-((CT_Yaw.*cos(matgamma))./(8.*sig.^2)))).*exp(-0.5.*C1.^2./sig.^2).*arrayfun(funi,U,O));
U_Wakexr = matUTurbines.*(1-(1-sqrt(1-((CT_Yaw.*cos(matgamma))./(8.*sig.^2)))).*exp(-0.5.*C1.^2./sig.^2).*sqrt(2/pi).*(erf((-O.^2)/2)-1));

3for i2=1:WP.nTurbines

    if negativeyaw(i2) == 1
    
        U_Wakexr(:,:,i2) = flipud(U_Wakexr(:,:,i2));

    end
end


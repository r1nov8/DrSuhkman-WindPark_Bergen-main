function [WP] = Windparkberechnung_opt(WP)
%1) Funktion zur Windparkberechnung (Aufruf im Optimierungsfall)
%2) a) Nachlauf für jede Turbine berechnen (Geschw. + Turbulenz)
%      (Ishihara Modell)
%   b) Interpoliere nachläufe in Globales Feld und Superpositioniere sich
%      überlappende Nachläufe (local2global)
%   c) Ermittle Geschwindigkeit und Turbulenz vor jedem Rotor
%3) Reduziert um sämtliche Textausgaben im Vergleich zur "normalen"
%   Berechnungsfunktion


%%%%%%%%%%%%%% %Schleife über Geschwindigkeitsfeld + Turbulenzfeld Berechnung %%%%%%%%%
i=0; %Für Timer / Textausgabe
while WP.sigma > 0.00001
i=i+1;

%% Berechnung Nachlauf -> Geschwindigkeit + Turbulenz

if WP.JG==1     %Jensen Gauss Berechnung
        [WP.matU_Wake] = JGWakemodel(WP);  %Funktionsaufruf -> AKTUELL NICHT FUNKTIONSTÜCHTIG
elseif WP.Dou==1            %Dou Yawmodell Berechnung
        [WP.matU_Wake] = DouYawmodel(WP);  %Funktionsaufruf -> AKTUELL NICHT FUNKTIONSTÜCHTIG
elseif WP.Ishihara==1
        [WP, WP.rWake] = Ishihara_Wake(WP,i); % -> Voll Funktionsfähiges Modell nach Qian & Ishihara
end

%% Interpolieren + Superpositionieren der Nachläufe im globalen Feld

[WP.C_Windpark, WP.I_Windpark, WP.sigma] = local2global(WP);

%% Ermittle neue Input Geschwindigkeit + Turbulenz für jede Turbine

[WP.vecUTurbines, WP.vecUTurbinesOLD, WP.vecITurbines, WP.vecURotorelements, WP.vecpitch, WP.rpm,  WP.lambda,...
    WP.vecCT_Turbines, WP.vecCP_Turbines, WP.vecP_Turbines, WP.xRotorglobplot, WP.yRotorglobplot] = getTurbineWindspeed(WP);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%% Leistungsberechnung nach BEMT %%%%%%%%%%%%%%%%%%%
[WP.vecP_Turbines, WP.PtotalWP] = Leistungsberechnung(WP.vecCP_Turbines, WP.vecP_Turbines, WP.density, WP.D, WP.vecUTurbines, WP);
end
function [vecUTurbines, vecUTurbinesOLD, vecITurbines, URotorelements, vecpitch, vecrpm, veclambda, vecCT_Turbines, vecCP_Turbines, vecP_Turbines, xRotorglobplot, yRotorglobplot] = getTurbineWindspeed(WP)

% 1. Ermittle Koordinate der Turbine
% 2. Ermittle Koordinatenvektor des Rotors
% 3. Bestimme Geschwindigkeiten an den Koordinaten aus Geschwindigkeitsfeld
% 4. Bilde Mittelwert über Rotor -> Vektor mit Geschwindigkeit für jede
% Turbine
% 5. Übergebe Vektor an WP Struct

RotorRes = 100; %Anzahl aufzulösende Rotorelemente 
vecRes = (-WP.D/2:WP.D/RotorRes:WP.D/2)'; %Vektor Rotorpunkte an denen Geschw. bestimmt werden soll

%Vektorisieren der Größen
matgamma=repmat(WP.vecgamma,[numel(vecRes),1]); %(RotorpunktexYawwinkel)
matR    =repmat(vecRes, [1,numel(WP.vecgamma)])/WP.D;

% Ermittle Koordinaten der Rotorpunkte für alle Turbinen (Lokal -
% Turbinenmittelpunkt = (0/0)
xRotor =  sin(-WP.alpha).*matR; %x Koordinaten der Rotorpunkte
yRotor =  cos(-WP.alpha).*matR; %y Koordinaten der Rotorpunkte

% Globale Koordinaten der Rotorkoordinaten
xRotorglob=zeros(numel(vecRes),numel(WP.vecgamma));
yRotorglob=zeros(numel(vecRes),numel(WP.vecgamma));
for i1 = 1:WP.nTurbines
    xRotorglob(:,i1) = xRotor(:,i1) + WP.vecXTurbines(i1)-0.5*cos(WP.alpha);
    yRotorglob(:,i1) = yRotor(:,i1) + WP.vecYTurbines(i1)-0.5*sin(WP.alpha);
end

%Interpoliere Geschwindigkeitswerte für alle Rotorpunkte

URotorelements=interp2(WP.xglobal,WP.yglobal,WP.C_Windpark,xRotorglob,yRotorglob);
IRotorelements=interp2(WP.xglobal,WP.yglobal,WP.I_Windpark,xRotorglob,yRotorglob);

%%%% Mean Rotor Value %%%%%
vecUTurbinesOLD=WP.vecUTurbines;
[vecUTurbines]=mean(URotorelements,1); %Mitteln über alle Rotorpunkte
[vecITurbines]=mean(IRotorelements,1);

%% Anpassen der Schub / Leistungsbeiwerte abhängig von der neuen Geschwindigkeit
if WP.FIVEMWReference==1
vecpitch_grad=WP.pitchcontrol(vecUTurbines);%Regelung Pitchwinkel
vecpitch=deg2rad(vecpitch_grad);
vecrpm=WP.rpmcontrol(vecUTurbines);%Regelung Drehzahl
veclambda        = 2.*pi.*(vecrpm/60)*(WP.D/2)./vecUTurbines; %Neuberechnung Schnelllaufzahl (Nach geänderter Anströmgeschwindigkeit und Drehzahl)
vecP_Turbines=[];
%Leistungs und Schubbeiwert neu Interpolieren (abh. von Lambda und
%Pitchwinkel
vecCT_Turbines=interp2(WP.vecpitchinput, WP.veclambdainput, WP.vecCTinput, vecpitch, veclambda, 'spline'); %Initialisiere CT für Turbinen
vecCP_Turbines=interp2(WP.vecpitchinput, WP.veclambdainput, WP.vecCPinput, vecpitch, veclambda, 'spline'); %Initialisiere CP für Turbinen
elseif WP.VestasV80==1
    vecpitch=[];
    vecrpm=[];
    veclambda=[];
    vecCP_Turbines=[];
    vecCT_Turbines=interp1(WP.vecCTinput(:,1),WP.vecCTinput(:,2),vecUTurbines); %Initialisiere CT für Turbinen
    vecP_Turbines=interp1(WP.vecPinput(:,1),WP.vecPinput(:,2),vecUTurbines); %Initialisiere P für Turbinen
end

%%%%%%% Plot Koordinaten erstellen und in WP speichern -> Für spätere Plot
%%%%%%% Funktion nötig
xRotorplot =  sin(-matgamma).*matR; %x Koordinaten der Rotorpunkte
yRotorplot =  cos(-matgamma).*matR; %y Koordinaten der Rotorpunkte

% Globale Koordinaten der Rotorkoordinaten
xRotorglobplot=zeros(numel(vecRes),numel(WP.vecgamma));
yRotorglobplot=zeros(numel(vecRes),numel(WP.vecgamma));
for i1 = 1:WP.nTurbines
    xRotorglobplot(:,i1) = xRotorplot(:,i1) + WP.vecXTurbines(i1);
    yRotorglobplot(:,i1) = yRotorplot(:,i1) + WP.vecYTurbines(i1);
end
end
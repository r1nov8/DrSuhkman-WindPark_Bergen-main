function [xRotorglobplot, yRotorglobplot] = getTurbineCoordinates(WP)

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
yRotor =  cos(-WP.alpha).*matR; %y KoordiYCalcPointsnaten der Rotorpunkte

% Globale Koordinaten der Rotorkoordinaten
xRotorglob=zeros(numel(vecRes),numel(WP.vecgamma));
yRotorglob=zeros(numel(vecRes),numel(WP.vecgamma));
for i1 = 1:WP.nTurbines
    xRotorglob(:,i1) = xRotor(:,i1) + WP.transp_vecXTurbines(i1)-0.5*cos(WP.alpha);
    yRotorglob(:,i1) = yRotor(:,i1) - WP.vecYTurbines(i1)+0.5*sin(WP.alpha);
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
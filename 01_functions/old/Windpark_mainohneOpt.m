%% Verzeichnisse Hinzufügen / Variablen löschen
clear all;
addpath('01_functions','02_inputs','03_results');
%%%%%%%%%%%%%%%%%%%%%%%%% Erstellen Datenstruktur aus Input %%%%%%%%%%%%%%%%%%%%%%%%%%%

WP=generateWP();
close all
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

%%%%%%%%%%%%%% %Schleife über Geschwindigkeitsfeld Berechnung %%%%%%%%%
i=0; %Zählt Iterationen
tic
while WP.sigma > 0.001 
i=i+1;
disp(['Iteration:' num2str(i)]);
t=toc;
%%%%%%%%%%%%% Ermittle Input Windgeschwindigkeit für jede Windturbine %%%%%%%%%%% 

[WP.vecUTurbines] = getTurbineWindspeed(WP);
t1=toc;
disp(['getTurbineWindspeed ' num2str(i) ' DURATION:' num2str(t1-t) 's'])
disp('%%%%')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Wake Berechnung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if WP.JG==1     %Jensen Gauss Berechnung
        [WP.matU_Wake] = JGWakemodel(WP);  %Funktionsaufruf
else            %Dou Yawmodell Berechnung
        [WP.matU_Wake] = DouYawmodel(WP);  %Funktionsaufruf
end
t2=toc;
disp(['Wakecalculation ' num2str(i) ' DURATION:' num2str(t2-t1) 's'])
disp('%%%%')


% %%%%%%%%%%%%%%  Interpolieren des Wakes in das globale Geschwindigkeitsfeld %%%%%%%%%%%%%

[WP.C_Windpark, WP.sigma] = lokal2global(WP);
t8=toc;
disp(['Local2Global ' num2str(i) ' DURATION:' num2str(t8-t2) 's'])

disp(['Abbruchkriterium bei SIGMA = ' num2str(WP.sigma)]);

disp([num2str(i) '.Iteration DURATION:' num2str(t8-t) 's'])
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Nachlauf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:(numel(WP.x_D))
figure(2);
hold on;
plot(WP.vec_r/WP.D, WP.matU_Wake(:,1,k)/WP.C_Wind);
hold off;
end
clear k
t=toc;
disp(['Gesamtzeit: ' num2str(t) 's'])
% %Plotte alle in einem Fenster
% for k=1:(numel(WP.x_D))
% figure(1);
% hold on;
% plot(WP.vec_r/WP.D, WP.U_Wake_xr(:,k)/WP.C_Wind);
% hold off;
% end
% 
% xlabel ('z/D_0');
% ylabel ('U_{Wake} / U_{Ref}');
% title('Nachlauf bei verschiedenen x/D');
% legendtxt=string(x');
% legendtxt='x/D = ' + legendtxt;
% legend(legendtxt);
% 
% %Plotte alle in einzelnen Fenstern
% for k=1:(numel(x))
%     
% figure(k+1)
% 
% plot(WP.vec_r/WP.D, U_Wake_xr(:,k)/WP.C_Wind);
% xlabel ('z/D_0');
% ylabel ('U_{Wake} / U_{Ref}');
% title (['Nachlauf bei x/D =', num2str(x(k))]);
% 
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Speichern der Wake-Ergebnisse %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% U = U_Wake_xr/WP.C_Wind; %U/U_Ref
% z = WP.vec_r/WP.D;     %z/D
% 
% if WP.JG==1
%     Mat_JGWake=[[nan, x];[z', U]];
%     save('03_results\JGValidation.mat', 'Mat_JGWake');
% else
%     Mat_DOUWake=[[nan, x];[z', U]];
%     save('03_results\DOUValidation.mat', 'Mat_DOUWake');
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
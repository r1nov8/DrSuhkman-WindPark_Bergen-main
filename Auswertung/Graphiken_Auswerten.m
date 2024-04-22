%Plotte Graphen wie im Inputfile angefragt
I=1;
%% Powerplot
if Windpark.plot_Leistungsabfall==true
    figure(1+10*I)
    if Windpark.nTurbines == 80
        plot(1:10,Windpark.vecP_Turbines([4 12 20 28 36 44 52 60 68 74])/Windpark.vecP_Turbines(1),"*-",'LineWidth',2);%Windpark.vecP_Turbines([4 13 23 23 43])
        ylim([0.2,1])
        ax=gca;
        ax.FontSize=15;
        xlabel('Row','FontSize',20)
        ylabel('Normalized Power P_x/P_1','FontSize',20)
        title('Leistungsabfall entlang einer Reihe')
    elseif Windpark.nTurbines == 12
        plot(1:12,Windpark.vecP_Turbines(1:12)/Windpark.vecP_Turbines(1),"*-",'LineWidth',2);
        ylim([0.2,1])
        ax=gca;
        ax.FontSize=15;
        xlabel('Row','FontSize',20)
        ylabel('Normalized Power P_x/P_1','FontSize',20)
        title('Powerloss over 1 Row')
    elseif Windpark.nTurbines == 4
        plot(1:9,Windpark.vecP_Turbines/Windpark.vecP_Turbines(1),"*-",'LineWidth',2);
        ylim([0.2,1])
        ax=gca;
        ax.FontSize=15;
        xlabel('Row','FontSize',20)
        ylabel('Normalized Power P_x/P_1','FontSize',20)
        title('Powerloss over 1 Row')
    end
end

% %Wenn Cluster -> Reinkommentieren
% 
% % Geschwindigkeitsfeld
% if Windpark.plot_Geschwindigkeitsfeld==true
% figure(2+10*I)
% hold on
% title('Geschwindigkeitsfeld')
% surf(Windpark.xglobal,-Windpark.yglobal,Windpark.C_Windpark/Windpark.C_Wind,"Facecolor","interp",LineStyle,"none"); % Ohne Zelllinien
% % surf(Windpark.xglobal,Windpark.yglobal,C_Windpark_neu,"Facecolor","interp"); % Mit Zelllinien
% colormap jet
% colorbar;
% ylabel('y/D Nondimensional');
% xlabel('x/D Nondimensional');
% view(2)
%     %%Plotte Rotor falls gewünscht
%     if Windpark.plot_Rotor==true
%         for i2 = 1:Windpark.nTurbines
%             z=1.1+zeros(size(Windpark.xRotorglobplot));
%             plot3(Windpark.xRotorglobplot(:,i2),-Windpark.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0, Color,'k')
%             view(2)
%         end
%     end
%     hold off
% end
% 
% %% Turbulenzfeld
% if Windpark.plot_Turbulenzfeld==true
% figure(3+10*I)
% hold on
% title('Turbulenzfeld')
% surf(Windpark.xglobal,-Windpark.yglobal,Windpark.I_Windpark/Windpark.Ia,"Facecolor","interp",LineStyle,"none"); % Ohne Zelllinien
% % surf(Windpark.xglobal,Windpark.yglobal,C_Windpark_neu,"Facecolor","interp"); % Mit Zelllinien
% colormap jet
% colorbar;
% ylabel('y/D Nondimensional');
% xlabel('x/D Nondimensional');
% view(2)
%     %Plotte Rotor falls gewünscht
%     if Windpark.plot_Rotor==true
%         for i2 = 1:Windpark.nTurbines
%             z=11.1+zeros(size(Windpark.xRotorglobplot));
%             plot3(Windpark.xRotorglobplot(:,i2),-Windpark.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0,Color,'k')
%             view(2)
%         end
%     end
% hold off
% end

% Wenn Cluster -> Rauskommentieren 
%% Geschwindigkeitsfeld
if Windpark.plot_Geschwindigkeitsfeld==true
figure(2+10*I)
hold on
title('Geschwindigkeitsfeld')
surf(Windpark.xglobal,-Windpark.yglobal,Windpark.C_Windpark/Windpark.C_Wind,"Facecolor","interp",LineStyle="none"); % Ohne Zelllinien
% surf(Windpark.xglobal,Windpark.yglobal,C_Windpark_neu,"Facecolor","interp"); % Mit Zelllinien
colormap jet
colorbar;
ylabel('y/D Nondimensional');
xlabel('x/D Nondimensional');
view(2)
    %%Plotte Rotor falls gewünscht
    if Windpark.plot_Rotor==true
        for i2 = 1:Windpark.nTurbines
            z=1.1+zeros(size(Windpark.xRotorglobplot));
            plot3(Windpark.xRotorglobplot(:,i2),-Windpark.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0, 'Color','k')
            view(2)
        end
    end
    hold off
end

%% Turbulenzfeld
if Windpark.plot_Turbulenzfeld==true
figure(3+10*I)
hold on
title('Turbulenzfeld')
surf(Windpark.xglobal,-Windpark.yglobal,Windpark.I_Windpark/Windpark.Ia,"Facecolor","interp",LineStyle="none"); % Ohne Zelllinien
% surf(Windpark.xglobal,Windpark.yglobal,C_Windpark_neu,"Facecolor","interp"); % Mit Zelllinien
colormap jet
colorbar;
ylabel('y/D Nondimensional');
xlabel('x/D Nondimensional');
view(2)
    %Plotte Rotor falls gewünscht
    if Windpark.plot_Rotor==true
        for i2 = 1:Windpark.nTurbines
            z=11.1+zeros(size(Windpark.xRotorglobplot));
            plot3(Windpark.xRotorglobplot(:,i2),-Windpark.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0,'Color','k')
            view(2)
        end
    end
hold off
end


%% Nachlauf
if Windpark.plot_Nachlaufverteilung==true

%Wake Plot über alle berechneten r/x einer Turbine
for k=1:(numel(Windpark.x_D))
    figure(4+10*I);
    hold on;
    plot(Windpark.vec_r/Windpark.D, Windpark.matU_Wake(:,k,1)/Windpark.C_Wind);
    hold off;
end
clear k
xlim([-2,2])
xlabel ('z/D_0');
ylabel ('U_{Wake} / U_{Ref}');
title('Nachlauf bei verschiedenen x/D');
legendtxt=string(Windpark.x_D');
legendtxt='x/D = ' + legendtxt;
legend(legendtxt);

%Plotte alle in einzelnen Fenstern
for k=1:(numel(x))
    
figure(k+5)

plot(Windpark.vec_r/Windpark.D, U_Wake_xr(:,k)/Windpark.C_Wind);
xlabel ('z/D_0');
ylabel ('U_{Wake} / U_{Ref}');
title (['Nachlauf bei x/D =', num2str(x(k))]);

end

for i1=1:(Windpark.nTurbines)
figure(i1)
for k=1:(numel(Windpark.x_D))
hold on;
plot(Windpark.vec_r/Windpark.D, Windpark.matU_Wake(:,k,i1)/Windpark.C_Wind);
hold off;
end
end
end

%% Turbulenz
    if Windpark.plot_Turbulenzverteilung==true
        figure(6+10*I);
        for i=2:numel(Windpark.x_D)
            hold on
            plot(((Windpark.matWakeTurbulence(:,i,1)*2./0.3)+Windpark.x_D(i)),Windpark.rWakeinit(:,i,1)/D)
            xlim([0,14])
            ylim([-2,2])
            xlabel ('x/D');
            ylabel ('z/D');
            title('Turbulenzverteilung bei verschiedenen x/D');
        end
    end

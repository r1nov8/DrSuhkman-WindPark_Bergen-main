function [WP] = plots(WP,I)
%Plots as requested in input filePlotte Graphen wie im Inputfile angefragt
%% Powerplot
if WP.plot_Leistungsabfall==true
    figure(1+10*I)
    if WP.nTurbines == 75
        plot(1:7,WP.vecP_Turbines([6 11 22 33 44 55 66])/WP.vecP_Turbines(5),"*-",'LineWidth',2);%WP.vecP_Turbines([4 12 20 28 36 44 52 60 68 74])
        ylim([0.2,1])
        ax=gca;
        ax.FontSize=15;
        xlabel('Row','FontSize',20)
        ylabel('Normalized Power P_x/P_1','FontSize',20)
        title('Powerloss over 1 Row')
        xlim([1,7])
        ylim([0.2,1.1])
    elseif WP.nTurbines == 12
        plot(1:12,WP.vecP_Turbines(1:12)/WP.vecP_Turbines(1),"*-",'LineWidth',2);
        ylim([0.2,1])
        ax=gca;
        ax.FontSize=15;
        xlabel('Row','FontSize',20)
        ylabel('Normalized Power P_x/P_1','FontSize',20)
        title('Powerloss over 1 Row')
    else 
        plot(1:WP.nTurbines,WP.vecP_Turbines/WP.vecP_Turbines(1),"*-",'LineWidth',2);
        ylim([0.2,1])
        ax=gca;
        ax.FontSize=15;
        xlabel('Row','FontSize',20)
        ylabel('Normalized Power P_x/P_1','FontSize',20)
        title('Powerloss over 1 Row')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Wenn Cluster -> Reinkommentieren
% 
% %%Velocity field
 if WP.plot_Geschwindigkeitsfeld==true
 figure(2+10*I)
 hold on
 title('Velocity field')
surf(WP.xglobal,-WP.yglobal,WP.C_Windpark/WP.C_Wind,"Facecolor","interp",LineStyle="none"); % Without cell lines
%surf(WP.xglobal,WP.yglobal,C_Windpark_neu,"Facecolor","interp"); % With cell lines
colormap(inferno)
colorbar;
ylabel('y/D Nondimensional');
xlabel('x/D Nondimensional');
ylim([-10, 70])
xlim([-5, 40])
view(2)
    %%Plotte Rotor if desired
    if WP.plot_Rotor==true
        for i2 = 1:WP.nTurbines
            z=1.1+zeros(size(WP.xRotorglobplot));
            plot3(WP.xRotorglobplot(:,i2),-WP.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0, 'Color', 'k')
            view(2)
        end
    end
    hold off
end

%% Turbulence field
if WP.plot_Turbulenzfeld==true
figure(3+10*I)
hold on
title('Turbulence field')
surf(WP.xglobal,-WP.yglobal,WP.I_Windpark/WP.Ia,"Facecolor","interp",LineStyle="none"); % Without cell lines
%surf(WP.xglobal,WP.yglobal,C_Windpark_neu,"Facecolor","interp"); % With cell lines
colormap(viridis)
colorbar;
ylabel('y/D Nondimensional');
xlabel('x/D Nondimensional');
ylim([-10, 70])
xlim([-5, 40])
view(2)
    %Plotte Rotor if desired
    if WP.plot_Rotor==true
        for i2 = 1:WP.nTurbines
            z=11.1+zeros(size(WP.xRotorglobplot));
            plot3(WP.xRotorglobplot(:,i2),-WP.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0,'Color','k')
            view(2)
        end
    end
hold off
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Wenn Cluster -> Rauskommentieren 
%% First transpose global coordinates back
x=((WP.XCalcPoints(:,:,1)+WP.transp_vecXTurbines(1)).*cos(WP.alpha))-((WP.YCalcPoints(:,:,1)+WP.transp_vecYTurbines(1))*sin(WP.alpha));
y=((WP.XCalcPoints(:,:,1)+WP.transp_vecXTurbines(1)).*sin(WP.alpha)+(WP.YCalcPoints(:,:,1)+WP.transp_vecYTurbines(1)).*cos(WP.alpha)); %turbine 0/0 point
% %% Velocity field
% if WP.plot_Geschwindigkeitsfeld==true
% figure(2+10*I)
% hold on
% title('Velocity field')
% surf(x,y,WP.C_Windpark/WP.C_Wind,"Facecolor","interp",LineStyle="none"); % Ohne Zelllinien
% % surf(WP.xglobal,WP.yglobal,C_Windpark_neu,"Facecolor","interp"); % Mit Zelllinien
% colormap(inferno)
% colorbar;
% ylabel('y/D Nondimensional');
% xlabel('x/D Nondimensional');
% view(2)
%     %%Plotte Rotor falls gewünscht
%     if WP.plot_Rotor==true
%         for i2 = 1:WP.nTurbines
%             z=1.1+zeros(size(WP.xRotorglobplot));
%             plot3(WP.xRotorglobplot(:,i2),WP.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0, 'Color','k')
%             view(2)
%         end
%     end
%     hold off
% end
% 
% %% Turbulenzfeld
% if WP.plot_Turbulenzfeld==true
% figure(3+10*I)
% hold on
% title('Turbulenzfeld')
% surf(x,y,WP.I_Windpark/WP.Ia,"Facecolor","interp",LineStyle="none"); % Ohne Zelllinien
% % surf(WP.xglobal,WP.yglobal,C_Windpark_neu,"Facecolor","interp"); % Mit Zelllinien
% colormap(inferno)
% colorbar;
% ylabel('y/D Nondimensional');
% xlabel('x/D Nondimensional');
% view(2)
%    %Plotte Rotor falls gewünscht
%    if WP.plot_Rotor== true
%        for i2 = 1:WP.nTurbines
%            z=11.1+zeros(size(WP.xRotorglobplot));
%            plot3(WP.xRotorglobplot(:,i2),WP.yRotorglobplot(:,i2),z(:,i2),'LineWidth',2.0,'Color','k')
%            view(2)
%        end
%    end
% hold off
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end

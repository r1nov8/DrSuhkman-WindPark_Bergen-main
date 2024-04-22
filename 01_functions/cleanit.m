function [WP] = cleanit(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleans result struct of unneccesary temporary matrices  %
% Returns lean struct                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if WP.GraphicalOutput==true && WP.plot_Geschwindigkeitsfeld || ...
%     WP.GraphicalOutput==true && WP.plot_Turbulenzfeld
% rem={'vecindTurbines';'vecUTurbinesOLD'; 'indTurbinesinterp';'xglobalinterp';'yglobalinterp';...
%     'x_Wake';'y_Wake';'indTurbines';'id_X_interp';'id_Y_interp';'id_XY_interp'; 'matUwake_global';...
%     'matIwake_global'; 'tmpmat'; 'tmpsum'; 'idkorr'; 'idx'; 'x';'cosgamma';'singamma';'XCalcPoints';...
%     'YCalcPoints';'matU_Wake';'deltaI_Rotor';'vecUTurbines_rad';'vecITurbines_rad'};
% else
if WP.Comp_AEP==false
rem={'vecindTurbines';'vecUTurbinesOLD';'tmpmat'; 'tmpsum';'cosgamma';'singamma';'XCalcPoints';...
    'YCalcPoints';'matU_Wake';'deltaI_Rotor';'vecITurbines_rad'}; %'vecUTurbines_rad'

% end

WP=rmfield(WP,rem); %% Variablen löschen die nicht gespeichert werden sollen
end

end
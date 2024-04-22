function [WP] = wind_farm_computation4_opt(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computational function for optimisation                 %
% Identical to "Windparkcomputation" -> Reduced comments/ %
% user output                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% Loop for iterative turbine inflow comp. %%%%%%%%%
i=0; %For display output
while WP.sigma > WP.sigmaMIN % Check if termination criterion is met
i=i+1;
%% Computation wake effect of each individual turbine
 if WP.Ishihara==1
        [WP] = Ishihara_Wake_Computation(WP,WP.XCalcPoints,WP.YCalcPoints,WP.v_transverse,WP.YCoordinates_Wakecenter,0, 0);
        if WP.momCons_superpos==true
        [WP] = Ishihara_Wake_Computation(WP,WP.x_Uc_global,WP.y_Uc_global,WP.v_transverse4convection,WP.YCoordinates_Wakecenter4convection,0, 1); %Compute all necessary points for convection velocity
        end
 end
%% Superimpose individual wake effects
    [WP, WP.sigma] = superposition(WP, i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Power calculation acc. to power curve %%%%%%%%%%%%%%%%%%%
[WP.vecP_Turbines, WP.PtotalWP] = Leistungsberechnung(WP.vecCP_Turbines, WP.vecP_Turbines, WP.density, WP.D, WP.vecUTurbines, WP);
end

function [WP] = Windparkcomputation(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computational function for graphical output             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Loop for iterative turbine inflow comp. %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WP.tid=0;
i=0; %For display output
while WP.sigma > WP.sigmaMIN % Check if termination criterion is met
i=i+1;
if WP.Comp_AEP==false
disp(['Iteration: ', num2str(i)])
end
%% Computation wake effect of each individual turbine
 if WP.Ishihara==1 
        %Compute all necessary points at each rotor
        [WP] = Ishihara_Wake_Computation(WP,WP.XCalcPoints,WP.YCalcPoints,WP.v_transverse,WP.YCoordinates_Wakecenter,0, 0);
        if WP.momCons_superpos==true 
        %Compute all necessary points for convection velocity
        [WP] = Ishihara_Wake_Computation(WP,WP.x_Uc_global,WP.y_Uc_global,WP.v_transverse4convection,WP.YCoordinates_Wakecenter4convection,0, 1);         end
 end
%% Superimpose individual wake effects
    [WP, WP.sigma] = superposition(WP, i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Power calculation acc. to power curve %%%%%%%%%%%%%%%%%%%
[WP.vecP_Turbines, WP.PtotalWP] = Leistungsberechnung(WP.vecCP_Turbines, WP.vecP_Turbines, WP.density, WP.D, WP.vecUTurbines, WP);
WP.iterations=i;
end

function [WP] = GraphicalComputation(WP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computes Velocity/ Turbulence field if graphical output is requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Safe initial settings -> as long as graphical output doesnt work
momCons_init=WP.momCons_superpos;
Wake_Meandering_init=WP.Wake_Meandering;
WP.momCons_superpos=false;
WP.Wake_Meandering=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[WP] = Initialisation_GraphicalOutput2(WP); % Initialise huge matrices to block RAM

 if WP.Ishihara==1 % Compute the single wake
        [WP] = Ishihara_Wake_Computation(WP,WP.XCalcPoints,WP.YCalcPoints,WP.v_transverse,WP.YCoordinates_Wakecenter,1, 0);
 end

i=0; %For display output
WP.sigma=100;
while WP.sigma > 0.0000001 % Check if termination criterion is met
% for I=1:2
i=i+1;
if WP.momCons_superpos==true
disp(['Iteration Graphical computation: ', num2str(i)])
end
%% Interpolation + Superposition of computed wakes
[WP.C_Windpark, WP.I_Windpark, WP.Uc, WP.sigma] = superposition_GraphicalOutput(WP, i);
end
%% Get coordinates of each rotor for rotorlines
[WP.xRotorglobplot, WP.yRotorglobplot] = getTurbineCoordinates(WP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Return settings to input state for proper reult file doc
WP.momCons_superpos=momCons_init;
WP.Wake_Meandering=Wake_Meandering_init;

end

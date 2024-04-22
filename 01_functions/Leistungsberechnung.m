function [vecP_Turbines, PtotalWP, veclambda] = Leistungsberechnung(vecCP_Turbines, vecP_Turbines, density, D, vecUTurbines, WP)

%% %%%%%%%Leistungsberechung%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function evaluates the predicted power output of   %
% each turbine.                                           %
% The Inflow velocities determined in the previous,       %
% iterative loop are used                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vecP0_Turbines = density*pi/4*D^2*vecUTurbines.^3/2; %Theoretical wind power at every turbines position

if WP.FIVEMWReference==1
%Turbine power with respect to theoretical wind power, power coefficient + yaw angle
[vecP_Turbines]  = vecCP_Turbines.*vecP0_Turbines.*cos(WP.vecYaweff).^2; 
elseif WP.VestasV80==1
%Turbine power with respect to theoretical wind power, power coefficient + yaw
[vecP_Turbines]  = vecP_Turbines.*cos(WP.vecYaweff).^2;   
end 
if any(isnan(vecP_Turbines))
   vecP_Turbines(isnan(vecP_Turbines))=0;
end
[PtotalWP]       = sum(vecP_Turbines); %Summing up the power of all turbines -> Farm power

end
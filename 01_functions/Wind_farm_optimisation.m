function [Gesamtleistung] = Wind_farm_optimisation(x,WP)
%1) Adapts all parameters to the changing layout or yaw angles (X/Y
%coordinates or yaw angles)
%2) Calls the target function identical to normal computation function but with reduced output-> AEP_Computation
%3) Returns the negative value of the predicted withfarm AEP -> Target value of fmincon


if WP.Optimiere_Yawwinkel==true
%Overwrite Yaw angle
WP.vecgamma_grad  = x; 

%Redefine all values dependand on the yaw angle
    %%Excerpt from INPUT File
    WP.vecgamma       = deg2rad(WP.vecgamma_grad);
    WP.vecYaweff_grad = WP.vecgamma_grad-WP.alpha_grad;
    WP.vecYaweff      = deg2rad(WP.vecYaweff_grad);
    %%Excerpt from initialisation function
    WP.cosgamma=cos(WP.vecYaweff);
    WP.singamma=sin(WP.vecYaweff);
end
if WP.Optimiere_Koordinaten==true || WP.Comp_AEP==true
%Overwrite coordinates
WP.vecXTurbines=x(1,:);
WP.vecYTurbines=x(2,:);
end
WP=AEP_Computation(WP); %Target function

%Nan filter
if isnan(WP.AEPinGWH)
Gesamtleistung=Inf;
else
Gesamtleistung=-WP.AEPinGWH;
end

end
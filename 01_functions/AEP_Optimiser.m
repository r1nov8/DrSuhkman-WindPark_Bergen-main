function [WP] = AEP_Optimiser(WP)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function defines optimisation problem for     %
% fmincon -> for layout optimisation for AEP    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nStart=WP.nStart; %Number of starting points
%Define optimisation function
fun = @(x) Wind_farm_optimisation(x,WP);
A=[];
b=[];
Aeq=[];
beq=[];

%Upper/ Lower Limit
  lowerLim=WP.XYlowerLim;
  upperLim=WP.XYupperLim;
%Circular limits/ HR1 limits
  if WP.VestasV80==1
    nonlcon=@(x) circularboundaries(x);
elseif WP.FIVEMWReference==1
    nonlcon=@(x) circularboundaries4NREL(x);
  end

x0=WP.matSTART;

% Defin optimproblem & Call fmincon
options = optimoptions('fmincon','Algorithm',WP.Algorithm,'Display','iter','MaxFunctionEvaluations',100000,'OptimalityTolerance',1.0e-3);
[Koordinaten_Optimiert,Gesamtleistung_Optimierung] = fmincon(fun,x0,A,b,Aeq,beq,lowerLim,upperLim,nonlcon,options);


WP.Koordinaten_Optimiert=Koordinaten_Optimiert; % Save optimised coordinates/ layout
WP.AEP_Optimised=-Gesamtleistung_Optimierung; %Turn sign -> optimisationfunction == minimisation function
[~,id]=max(WP.AEP_Optimised); %get combination with highest modelled AEP

% Analyse & compute with optimised data
WP.vecXTurbines     = WP.Koordinaten_Optimiert(1,:,id);
WP.vecYTurbines     = WP.Koordinaten_Optimiert(2,:,id);

%% Compute wind farm AEP one last time with optimised data -> For Result file
WP=AEP_Computation(WP);


end
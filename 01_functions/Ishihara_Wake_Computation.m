function [WP] = Ishihara_Wake_Computation(WP, XPoints, YPoints, v_transverse, YCoordinates_Wakecenter, graphicalCall,Superposflag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Implemented wake-model according to Ishihara-Qian   %
%   wake model (2018)                                   % 
% - Computing speed deficit and turbulence induction    %
%   for each individual turbine considering yaw deflec. %
% Considers                                             %
% Returns:                                              %
% DELTA u (related to the inflow vel. of each rotor)    %
% DELTA I (related to the inflow turb. of each rotor)   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additions:                                                                                                     %
% 1) Computes sigma_m -> Wake meandering correction by Braunbehrens & Segalini (2019)                            %
% 2) Computes u_convect -> Convection velocity for momentum conserving superposition by Zong & Porté-Agel (2020) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Alter CT for yawed turbines %%%%%%%%%%%%
CTYaw=WP.cosgamma.^3.*WP.vecCT_Turbines;

%% Prepare data for Velocity computation
%%Constants (k= empiric Wake decay constant, rest empric data)
k=0.11.*CTYaw.^1.07.*WP.vecITurbines.^0.2;
epsilon=0.23.*CTYaw.^-0.25.*WP.vecITurbines.^0.17;
if WP.Deflection_Superposition==true && any(WP.vecYaweff_grad(1:end))==true
epsilon0Yaw=0.23.*WP.vecCT_Turbines.^-0.25.*WP.vecITurbines.^0.17; %Epsilon in non yawed state (for wake deflection superposition)
end
a=0.93.*CTYaw.^-0.75.*WP.vecITurbines.^0.17;
b=0.42.*CTYaw.^0.6.*WP.vecITurbines.^0.2;
c=0.15.*CTYaw.^-0.25.*WP.vecITurbines.^-0.7;

%Skew Angle Near Wake
theta0= (0.3.*WP.vecYaweff./WP.cosgamma).*(1-sqrt(abs(1-CTYaw)));

%Normal distribution at transition NearWake->FarWake for yawed turbines
sigma0=WP.D.*sqrt(CTYaw.*abs((WP.singamma./(44.4.*theta0.*WP.cosgamma))+0.042));
sigma0(WP.vecYaweff_grad==0)=nan;

%Axial position of the transition point NearWake ->FarWake
x0=WP.D.*((sigma0./WP.D)-epsilon)./k;
%Deflection 
yd0=theta0.*x0; %Deflection transition point (near2farwake)

%Prepare angles, CT and Ambient Turbulence vectors
cosgamma=WP.cosgamma;
singamma=WP.singamma;
CT=WP.vecCT_Turbines;
I0=WP.vecITurbines;
C0=WP.vecUTurbines;

%% Prepare data for Turbulence Computation
d=2.3.*CTYaw.^(-1.2);
e=I0.^0.1;
%% Initialise temporary matricess
sigma_3D=zeros(size(XPoints));
sigma0Yaw_3D=zeros(size(XPoints));
y_3D=zeros(size(XPoints));
yd_3D=zeros(size(XPoints)); 

%% Compute wake deflection wake widths and transverse components
for i=1:numel(CTYaw)
x=XPoints(:,:,i)*WP.D;
x(x<0)=nan; %Assign nan to all points upstream of given turbine (points not to be calculated)
y=YPoints(:,:,i).*WP.D;
y(isnan(x))=nan;

%Initialise sigma & yd 
sigma=zeros(size(x));
if WP.Deflection_Superposition==true && any(WP.vecYaweff_grad(1:end))==true
sigma0Yaw=sigma;%For wake deflection superposition
end
yd=zeros(size(sigma));

%Normaldistribution
sigma=WP.D.*((k(i).*x./WP.D)+epsilon(i));
sigma_3D(:,:,i)=sigma;
if WP.Deflection_Superposition==true && any(WP.vecYaweff_grad(1:end))==true
sigma0Yaw=WP.D.*((k(i).*x./WP.D)+epsilon0Yaw(i));%For wake deflection superposition
sigma0Yaw_3D(:,:,i)=sigma0Yaw;
end

%Case differentiation: x<x0 -> Nearwake/ x>x0-> Farwake
deltax=x-x0(i); %Help matrix
%Deflection NearWake
idx=(deltax<=0);
yd(idx)=WP.D.*(theta0(i).*x(idx)./WP.D);
%Deflection FarWake
idx=(deltax>0);
yd(idx)=WP.D.*(sqrt(CT(i)).*singamma(i)./(18.24.*k(i).*cosgamma(i)).*log(abs((sigma0(i)./WP.D+0.21.*sqrt(CTYaw(i))).*(sigma(idx)./WP.D-0.21.*sqrt(CTYaw(i)))...
    ./((sigma0(i)./WP.D-0.21.*sqrt(CTYaw(i))).*(sigma(idx)./WP.D+0.21.*sqrt(CTYaw(i))))))+yd0(i)/WP.D);

%Deflected Radial component (without secondary steering effect)
y=y+yd;
y_3D(:,:,i)=y;
yd_3D(:,:,i)=yd;
end

%%
%Reshape basic data to fit 3D array computation scheme
    CTYaw=reshape(CTYaw, 1, 1, []);
    C0=reshape(C0, 1, 1, []);
    I0=reshape(I0, 1, 1, []);
    cosgamma=reshape(cosgamma, 1, 1, []);
    singamma=reshape(singamma, 1, 1, []);
%% Now compute convection velocity for momentum conserving superpositioning
if (WP.momCons_superpos==true || WP.Wake_Meandering==true) && Superposflag==0 %Compute only if Function call not for computing
    Rootterm=1-((CTYaw.*WP.D.^2)./(8.*sigma_3D(1,:,:).^2));
    Rootterm(Rootterm<0)=nan;
    WP.u_convect=C0.*(0.5+0.5.*sqrt(Rootterm));
end
%% Compute wake meandering 
if WP.Wake_Meandering==true    
    WP.sigmaV=0.7.*I0.*C0; %Fluctuation intensity
    if WP.Comp_AEP==false
%     WP.Lambda=0.41*WP.Hub/WP.sigmaV; %Length scale (Karman constant*Hub height/Fluctuation intensity);
    WP.Lambda=WP.Hub;
    end
    t=(XPoints.*WP.D)./WP.u_convect;
    sigma_meandering=sqrt(2.*WP.sigmaV.*WP.Lambda.^2.*((t./WP.Lambda)+exp(-t./WP.Lambda)-1));
end
%% Compute transverse velocity component introduced by turbine
if WP.Deflection_Superposition==true && any(WP.vecYaweff_grad(1:end))==true
    %Initialise temporary matricess
    x_transverse=zeros(size(YCoordinates_Wakecenter));
    sigma_transverse=zeros(size(YCoordinates_Wakecenter));
    sigma0Yaw_transverse=zeros(size(YCoordinates_Wakecenter));
    yd_transverse=zeros(size(YCoordinates_Wakecenter));
%Reshape matrices from y * x * turbine to turbine*x*turbine (for wake deflection)
for ii=1:WP.nTurbines
    for i=1:WP.nTurbines
    YCoordinates_Wakecenter(i,1:numel(XPoints(1,:,1)),ii)=YCoordinates_Wakecenter(i,1:numel(XPoints(1,:,1)),ii)+yd_3D(1,1:numel(XPoints(1,:,1)),i); 
    x_transverse(i,:,ii)=XPoints(1,:,ii);
    sigma_transverse(i,:,ii)=sigma_3D(1,:,ii);
    sigma0Yaw_transverse(i,:,ii)=sigma0Yaw_3D(1,:,ii);
    yd_transverse(i,:,ii)=yd_3D(1,:,ii);
    end
end
    
%% Now compute velocity with the use of precomputed yd
v_transverse=v_transverse.*0; %Reset transverse velocity
id=x_transverse>0;%Find points downstream of the turbines
    v_transverse=((-CTYaw.*C0.*cosgamma.^2.*singamma)./(8.*(sigma_transverse.*id).^2./(sigma0Yaw_transverse.*id).^2)).*(1+erf((x_transverse.*id)./WP.D))...
        .*exp(-((YCoordinates_Wakecenter.*id)+(yd_transverse.*id)).^2./(2.*(sigma_transverse.*id).^2));
    id=isnan(v_transverse);%Nanfilter
    v_transverse(id)=0;
    
end
%% Now compute y with secondary steering effect
if WP.Deflection_Superposition==true && any(WP.vecYaweff_grad(1:end))==true
y_secsteering=zeros(size(v_transverse(1,:,1)));%Preassign array
for i=1:numel(CTYaw) %check for each turbine of a secondary steering effect applies
    y_secsteering=y_secsteering*0;
    x_transverse_calc=x_transverse(:,:,i);
    %First weigthing of transverse velocity
        if graphicalCall==0 && Superposflag==0 
    id = (x_transverse_calc(1,:)<0 & x_transverse_calc(1,:)>-WP.upstreamDist); %Find all turbines upstream of given turbine, but not farther than a user set number
    WP.id_deflectionsuperpos(:,:,i)=id;
        elseif graphicalCall==1 || Superposflag==1
    id=WP.id_deflectionsuperpos(:,:,i); %Reuse ID from Computation 
        end
    id(i) = 0; % don't include given turbine itself
    v_transverse_weighted=v_transverse(i,:,id).*(C0(id)./(C0(i)^2)); %First compute weighted transverse velocity
    v_SUM=sum(v_transverse_weighted,3);%Now sum the influence of all upstream turbines
    
    idx=x_transverse_calc(i,:)>0; %Now find all points affected by the given turbine
    y_secsteering(idx)= v_SUM(idx).*x_transverse_calc(i,idx).*WP.D;%Now compute the wake deflection of each turbine due to secondary steering
    y_3D(:,1:numel(XPoints(1,:,1)),i)=y_3D(:,1:numel(XPoints(1,:,1)),i)-y_secsteering(:,1:numel(XPoints(1,:,1))); %Include secondary steering effect
end
end
%% then compute Speed deficits & turbulences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%First prepare vecors to match 3D arrays
a=reshape(a, 1, 1, []);
b=reshape(b, 1, 1, []);
c=reshape(c, 1, 1, []);
d=reshape(d, 1, 1, []);
e=reshape(e, 1, 1, []);
%Velocity deficits (Rotorpoints x Rotornumber x Rotornumber)
if Superposflag==0
    if WP.Wake_Meandering==true % Add statistical wake meandering sigma
WP.matU_Wake=(C0./((a+b.*(XPoints)+c.*(1+(XPoints)).^-2).^2)).*(1+(sigma_meandering./sigma_3D).^2).^(-1/2).*exp(-y_3D.^2./(2*((sigma_3D.^2)+sigma_meandering.^2)));
    elseif WP.Wake_Meandering==false
WP.matU_Wake=C0./((a+b.*(XPoints)+c.*(1+(XPoints)).^-2).^2).*exp(-y_3D.^2./(2*sigma_3D.^2));
    end
elseif Superposflag==1
     if WP.Wake_Meandering==true
WP.VelocityDef4Uc=(C0./((a+b.*(XPoints)+c.*(1+(XPoints)).^-2).^2)).*(1./sqrt(1+(sigma_meandering./sigma_3D).^2)).*exp(-y_3D.^2./(2*(sigma_3D.^2+sigma_meandering.^2)));
% WP.VelocityDef4Uc(WP.VelocityDef4Uc<1.0e-3)=0;    
     elseif WP.Wake_Meandering==false
WP.VelocityDef4Uc=C0./((a+b.*(XPoints)+c.*(1+(XPoints)).^-2).^2).*exp(-y_3D.^2./(2*sigma_3D.^2));
% WP.VelocityDef4Uc(WP.VelocityDef4Uc<1.0e-3)=0;
     end
end

%% Compute induced Turbulences
if Superposflag==0 %Only if computation is not done for convection velocity
%Prepare konstants
q=(0.7.*(CTYaw.^-3.2).*(I0.^-0.45))./((1+XPoints).^2);
G=1./(d+(e.*XPoints)+q);
% 2 cases -> Turbulence radially close to: c1.Hub / 2.Tip
k1=zeros(size(y_3D)); %Correction factor 1
k2=k1;             %Correction factor 2

idx=(abs((y_3D./WP.D))<=0.5); %Hub
k1(idx)=cos(pi/2.*((abs(y_3D(idx))./WP.D)-0.5)).^2;
k2(idx)=cos(pi/2.*((abs(y_3D(idx))./WP.D)+0.5)).^2;

idx=(abs((y_3D./WP.D))>0.5); %Tip
k1(idx)=1;
k2(idx)=0;

     if WP.Wake_Meandering==true % Add statistical wake meandering sigma
%Normal distribution of turbulence
phi=k1.*exp(-(abs(y_3D)-WP.D/2).^2./(2.*(sigma_3D.^2+sigma_meandering.^2))) + k2.*exp(-(y_3D+WP.D/2).^2./(2.*(sigma_3D.^2+sigma_meandering.^2)));
%Rotor induced turbulence
WP.deltaI_Rotor=G.*(1./sqrt(1+(sigma_meandering./sigma_3D).^2)).*phi;
    elseif WP.Wake_Meandering==false
%Normal distribution of turbulence
phi=k1.*exp(-(abs(y_3D)-WP.D/2).^2./(2.*sigma_3D.^2)) + k2.*exp(-(y_3D+WP.D/2).^2./(2.*sigma_3D.^2));
%Rotor induced turbulence
WP.deltaI_Rotor=G.*phi;
     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Postprocessing data
if Superposflag==0
idnan=isnan(WP.matU_Wake);
WP.matU_Wake(idnan)=0; % points of nan have 0 contribution to the wake at given rotor
idnan=isnan(WP.deltaI_Rotor);
WP.deltaI_Rotor(idnan)=0; % points of nan have 0 contribution to the wake at given rotor
end
if WP.momCons_superpos==true
idnan=isnan(WP.u_convect);
WP.u_convect(idnan)=0;
if WP.momCons_superpos==true && Superposflag==1
idnan=isnan(WP.VelocityDef4Uc);
WP.VelocityDef4Uc(idnan)=0;  
end
end
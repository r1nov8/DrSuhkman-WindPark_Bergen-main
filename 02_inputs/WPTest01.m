function A = WP()
A=struct();
%true= Berechnung/Optimierung wird durchgeführt und etw. Ergebnisse im Zielordner überschrieben 
%false= Lade Ergebnisse mit demselben Namen wie unter A.name
% Off=5;
A.Calc=true;
A.sigmaMIN=0.0001;
%% Windparkdata
% Name wind farm
A.name = 'WP_Test01';
% Number of turbines
A.nTurbines = 150;
A.vecindTurbines = 1:A.nTurbines;
%Turbine model
A.VestasV80=1;
A.FIVEMWReference=0;
if A.VestasV80==1
    A.D=126;
     A.Hub=90;
%    A.Hub=0.8*A.D;
elseif A.FIVEMWReference==1
    A.D=126;
%     A.Hub=31.5;
    A.Hub=0.8*A.D;
end

% Turbine layout in x/D ->First turbine always (0/0)
%% HornsRev1_Reference
A.vecXTurbines = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 7.20 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 14.40 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 21.60 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 28.80 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 36.00 ];
A.vecYTurbines = -[0.00 7.20 14.40 21.60 28.80 36.00 43.20 50.40 57.60 64.80 72.00 79.20 86.40 93.60 100.80 108.00 115.20 122.40 129.60 136.80 144.00 151.20 158.40 165.60 172.80 0.00 7.20 14.40 21.60 28.80 36.00 43.20 50.40 57.60 64.80 72.00 79.20 86.40 93.60 100.80 108.00 115.20 122.40 129.60 136.80 144.00 151.20 158.40 165.60 172.80 0.00 7.20 14.40 21.60 28.80 36.00 43.20 50.40 57.60 64.80 72.00 79.20 86.40 93.60 100.80 108.00 115.20 122.40 129.60 136.80 144.00 151.20 158.40 165.60 172.80 0.00 7.20 14.40 21.60 28.80 36.00 43.20 50.40 57.60 64.80 72.00 79.20 86.40 93.60 100.80 108.00 115.20 122.40 129.60 136.80 144.00 151.20 158.40 165.60 172.80 0.00 7.20 14.40 21.60 28.80 36.00 43.20 50.40 57.60 64.80 72.00 79.20 86.40 93.60 100.80 108.00 115.20 122.40 129.60 136.80 144.00 151.20 158.40 165.60 172.80 0.00 7.20 14.40 21.60 28.80 36.00 43.20 50.40 57.60 64.80 72.00 79.20 86.40 93.60 100.80 108.00 115.20 122.40 129.60 136.80 144.00 151.20 158.40 165.60 172.80 ];
%% HornsRev1_Optimised
 %A.vecXTurbines = [0.027062776	0.748786536	1.689998333	2.700135581	3.606117281	4.467579223	5.333017234	6.005341171	3.788557309	4.458651985	5.409618441	6.732583586	8.206793733	9.372988634	10.34355519	11.36724457	10.6002449	11.33450959	12.34341081	13.71227918	14.94366246	16.075676	17.23101746	18.23576985	18.21559638	18.93576121	20.21273729	21.52483261	22.79774731	23.95323446	24.90973979	25.51006471	26.55995349	27.23554294	28.47603566	29.75967503	31.06167455	32.29502961	33.36829778	33.91035249	34.96226851	35.6436692	36.8144772	38.01822795	39.28458019	40.58827704	41.76656516	42.33675046	43.40575868	44.03062166	45.04619648	46.1738908	47.42754808	48.73605573	49.93011089	50.52505926	51.13524963	51.8885639	52.87043661	53.95073259	55.16538599	56.6571562	57.89558603	58.5234614	57.92935296	58.74278648	59.53691381	60.47083369	61.59278239	62.90761139	64.321067	65.1550997	62.99475738	63.64718091	64.52102543	65.42204536	66.32415759	67.27712093	68.24212654	68.9765172];
 %A.vecYTurbines = -[0.021583578	6.022213604	13.63122204	21.80358985	29.15678984	36.16071188	43.17509785	48.61453349	0.016155478	5.475233939	13.05285979	21.23996316	28.96570768	36.46469278	43.55158874	48.61284373	0.01917374	4.891919854	12.42821801	20.65376828	28.80553013	36.90001418	44.01431585	48.61255409	0.018722334	4.242712066	11.84365194	20.20384033	28.755475	37.2480585	44.57655961	48.60901899	0.020598433	3.758815673	11.4867092	19.99932029	28.65766173	37.32637783	44.90363021	48.61412983	0.017238119	3.720814784	11.41533448	19.85782278	28.51152914	37.23195225	44.90552963	48.61446286	0.018639603	3.841143901	11.50649798	19.76077765	28.27078206	37.0451009	44.81838325	48.61065395	0.020268301	4.396821815	11.72955674	19.74010844	27.9138289	36.3926521	44.14652541	48.60899134	0.016090703	4.889326858	12.11641969	19.72281674	27.47950961	35.54897388	43.29768489	48.61407421	0.015281193	5.297320448	12.38303986	19.69324519	27.02539868	34.73680343	42.54278611	48.60915921];
%% Free 2 Play
% A.vecXTurbines = [0 7 1 8];
% A.vecYTurbines = -[0 0 5 5];

%Yawwinkel in [°] -> Berechnung in Bogenmaß erfolgt automatisch
A.vecgamma_grad   = 0+zeros(1,A.nTurbines);
 %A.vecgamma_grad   = [-13.6074487001688	-13.5043703209599	-13.5996130413592	-13.5193843959764	-13.5533083345090	-13.6508905753604	-13.6764420919053	-14.9657480888596	-12.3693706486711	-12.3350549634728	-12.3465032459611	-12.4251907719866	-12.4082543777634	-12.3074767954164	-12.3146984320791	-13.7758902633300	-12.7499474923689	-12.5828737757049	-12.4998147372068	-12.5303500881749	-12.4237906450562	-12.5125705597567	-12.5630153172965	-13.6073459367595	-12.7612272873155	-12.3798234186896	-12.4783358512912	-12.4244214493418	-12.4749626165312	-12.4353254264839	-12.4297681963577	-13.1008490325008	-12.7658128972634	-12.3855559468243	-12.2270825741198	-12.2457362935789	-12.3000506487586	-12.2738172872551	-12.1945242474686	-12.6612076878007	-12.3291261873283	-11.9126386050207	-11.9731531752436	-11.8189841453435	-11.8662548808201	-11.9005036392743	-11.8366568819140	-12.1357878547310	-11.7689331437600	-11.1086288691330	-11.0895142893493	-11.2091618273472	-11.2363896073394	-10.9710021464518	-11.1389291294053	-11.0357490127379	-10.7085037425914	-10.0733234377807	-9.98084463523457	-10.0149423504115	-10.0479537295171	-9.95143699647550	-10.0022103100281	-9.97072566990145	-8.38957873889310	-7.82954614820651	-7.69395452207054	-7.67894669628194	-7.79152576051863	-7.82129011753748	-7.78092981963371	-7.79042298022906	5	5	5	5	5	5	5	5];
A.vecgamma        = deg2rad(A.vecgamma_grad);

% Ausgangspitchwinkel in [°] eingeben
A.pitch_grad =  zeros(1,A.nTurbines); %Ausgangspitchwinkel in Grad [°]
A.vecpitch   =  deg2rad(A.pitch_grad);
% Ausgangsdrehzahl der Turbinen [rpm]
A.rpm   = 7.6+zeros(1,A.nTurbines); %Ausgangsdrehzahl in [rpm]

% Abfrage ob 
if 5*A.nTurbines ~= numel(A.vecXTurbines) + numel(A.vecYTurbines) + numel(A.vecgamma_grad) + numel(A.vecpitch) + numel(A.rpm)
   error('Check coordinates and yaw angles!');
end

%% Ambient Data
A.Ia             = 0.07;     %Ambient Turbulence[-]
A.C_Wind         = 9.562868721;         %gjennomsnittlig vindhastighet [m/s]
A.alpha_grad     = 0;        %vindretning [°]
A.alpha          = A.alpha_grad*pi/180;
A.vecgamma_grad   =A.alpha_grad+zeros(1,A.nTurbines);
A.vecgamma        = deg2rad(A.vecgamma_grad);
A.density        = 1.225;
%TSR turbines
A.lambda         = (2.*pi.*(A.rpm./60).*(A.D./2))./A.C_Wind;
%Effective yaw Angle
A.vecYaweff_grad = A.vecgamma_grad-A.alpha_grad;
A.vecYaweff      = deg2rad(A.vecYaweff_grad);

%Initial inflow conditions for all turbines
A.vecUTurbinesOLD = zeros(1,A.nTurbines);
A.vecUTurbines    = A.C_Wind+zeros(1,A.nTurbines);%Inflow speed
A.vecITurbines    =A.Ia+zeros(1,A.nTurbines); %Inflow turbulence

%Theoretical wind power
A.P0    = A.density*pi/4*A.D^2*A.C_Wind^3/2;


%% Turbine data
if A.FIVEMWReference==1
    %%Load turbine data from WTToolbox
  load('/Users/kingston/Library/CloudStorage/OneDrive-HøgskulenpåVestlandet/Dokumenter/MATLAB/Bachelor-Havvind/WindPark_Bergen-main/05_Turbinen/WTToolbox_Output/WT5MW2.mat');

    A.vecpitchinput = WT.vecPitch;   %Pitchwinkel aus Toolbox
    A.veclambdainput= WT.veclambda;  %Schnelllaufzahl aus Toolbox
    A.vecrpminput   = WT.rpm;        %Drehzahl aus Toolbox
    A.vecCTinput = WT.CT;
    A.vecCPinput = WT.CP;
    
    %CT/ CP Vektor für alle Turbinen
    A.vecCT_Turbines=interp2(A.vecpitchinput, A.veclambdainput, A.vecCTinput, A.vecpitch, A.lambda, 'spline'); %Initialisiere CT für Turbinen
    A.vecCP_Turbines=interp2(A.vecpitchinput, A.veclambdainput, A.vecCPinput, A.vecpitch, A.lambda, 'spline'); %Initialisiere CP für Turbinen
    
    %Lade Matrix mit Daten für Pitch/ Drehzahlregelung (Turbinenabhängig)
    %Nur bei Verwendung der Referenzturbine (Regelkurven für Pitch und RPMbekannt)
    load('/Users/kingston/Library/CloudStorage/OneDrive-HøgskulenpåVestlandet/Dokumenter/MATLAB/Bachelor-Havvind/WindPark_Bergen-main/05_Turbinen/WTToolbox_Output/PitchControl_RPMControl.mat'); 
    A.pitchcontrol_Input=Pitch_RPM_Control(:,1:2);
    A.rpmcontrol_Input=Pitch_RPM_Control(:,3:4);
    %Pitchwinkel
    A.pitchcontrol=@(x)interp1(A.pitchcontrol_Input(:,1),A.pitchcontrol_Input(:,2),x); %Function Handle Pitchwinkelregelung während Berechnung
    % Drehzahl für alle Turbinen [1/min]
    A.rpmcontrol=@(x)interp1(A.rpmcontrol_Input(:,1),A.rpmcontrol_Input(:,2),x); %Function Handle Drehzahlregelung während Berechnung
elseif A.VestasV80==1
    load('/Users/kingston/Library/CloudStorage/OneDrive-HøgskulenpåVestlandet/Dokumenter/MATLAB/Bachelor-Havvind/WindPark_Bergen-main/05_Turbinen/VestasV80-2MW/IEA5MW.mat');
    A.vecCTinput=IEA5MW_CT;
    A.vecPinput=IEA5MW_P;
    A.vecCT_Turbines=interp1(A.vecCTinput(:,1),A.vecCTinput(:,2),A.vecUTurbines); %Initialisiere CT für Turbinen
    A.vecP_Turbines=interp1(A.vecPinput(:,1),A.vecPinput(:,2),A.vecUTurbines); %Initialisiere P für Turbinen
end



%% %%%%%%%% Wake modell data + Settings %%%%%%%%%%%%%%%%
%Wake model to use
A.Ishihara=1;  %Use Ishihara wake modell (Y/N)

%Secondary steering
A.Deflection_Superposition=false; %Use superposition of yaw deflection? (Y/N)
A.upstreamDist=15; %Transverse induced velocity of turbines upstream of given distance (D) will be 
                   %taken into account (Suggestion: 1-2x Turbinespacing)

%Superpositioning
A.momCons_superpos=true; %True  = For momentum conserving velocity superpositioning method (timeconsuming)
                         %False = Linear rotor based summation as defaul
                         %Turbulence is always superpositioned through quadratical, rotorbased summation
A.number_Uc_evaluation=200;

%Wake Meandering
A.Wake_Meandering=true; %Use wake meandering for time averaged wake meandering effect computation
 if A.Wake_Meandering==true
  A.sigmaV=0.7.*A.Ia.*A.C_Wind; %Fluctuation intensity
  A.Lambda=0.41*A.Hub/A.sigmaV; %Length scale (Karman constant*Hub height/Fluctuation intensity)
 end
% %Resolution of Rotor
A.RotorRes=100; %Number of points to be computed in each rotor plane

%% Computational settings
A.Berechnen = true;  %One time computation acc to given settings (Y/N)
%Parallel computation
A.nWorker=4; %Number of workers available
A.parallel=false; %(Y/N) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%AEP Switch + Wind Rose Data
A.Comp_AEP       =true;
%     Windrose=readtable('06_Windrose/HR_simplified_72x1.txt'); %Get Windrose Data Reduced
%     Windrose=readtable('06_Windrose/HR_resolved_120x22.txt'); %Get Windrose Data Reduced
    Windrose=readtable('/Users/kingston/Library/CloudStorage/OneDrive-HøgskulenpåVestlandet/Dokumenter/MATLAB/Bachelor-Havvind/WindPark_Bergen-main/06_Windrose/NORA2019.csv'); %Get Windrose Data Reduced
%   A.U_Windrose        =[8 9 10; 8.5 9.5 10.5; 7.5 8.5 9.5]; %All given Windspeeds Speed x Winddirection
%     A.U_Windrose        =[8; 8];  
%     A.alpha_Windrose    =[0 -48];
    A.U_Windrose        =table2array(Windrose(:,2));
    A.alpha_Windrose    =-table2array(Windrose(:,1))+270;
    A.LengthScale       =0.8.*A.D;                %3 Length scales for all given conditions 
    %Probabilities
%     A.Prob_U                   =[50 40 10; 50 40 10; 50 40 10];      %Probabilities of each speed per winddirection
%     A.Prob_alpha               =[40 30 30];                          %Probabilities of each winddirection given
%     A.Prob_Stability(:,:,1)    =[20 40 40; 20 40 40; 20 40 40];      %Probability of each Atmospheric stability(Linked to length scale)
%     A.Prob_Stability(:,:,2)    =[40 20 40; 40 20 40; 40 20 40];      %3D Matrix -> First Page Stable/ Second Page Neutral/ Third Page unstable cond.                                                                                                                                                                   
%     A.Prob_Stability(:,:,3)    =[40 40 20; 40 40 20; 40 40 20];
      A.Prob_alpha               =(table2array(Windrose(:,3)).*100)';
      A.Prob_U                   =100;
      A.Prob_Stability           =100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A.Optimieren=false; %Optimisation (Y/N)
A.Algorithm='interior-point';
A.nStart=1; %Number of starting points
%Either Yawangle optimisation OR Layout optimisation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A.Optimiere_Yawwinkel=false; %Optimise yaw angles (Y/N)

    if A.Optimiere_Yawwinkel==true       
        %Upper/ Lower Limit for Yawangles
        A.YawlowerLim=-40+zeros(1,A.nTurbines);
        A.YawupperLim=+40+zeros(1,A.nTurbines);
        %Provide starting conditions
                %%If A.nStart==1 choose:
       if A.nStart==1
        %A.vecgammaSTART=[-20 -20	-20	-20	-20	-20	-20	-20	-18	-18	-18	-18	-18	-18	-18	-18	-17	-17	-17	-17	-17	-17	-17	-17	-16	-16	-16	-16	-16	-16	-16	-16	-15	-15	-15	-15	-15	-15	-15	-15	-14	-14	-14	-14	-14	-14	-14	-14	-13	-13	-13	-13	-13	-13	-13	-13	-12	-12	-12	-12	-12	-12	-12	-12	-11	-11	-11	-11	-11	-11	-11	-11	0	0	0	0	0	0	0	0]; 
       A.vecgammaSTART=[-20 -20 -20 -20];
       elseif A.nStart>1
       %If A.nStart>1 choose:
       rng('default')
       A.vecgammaSTART=randi([A.YawlowerLim(1) A.YawupperLim(1)],[A.nStart length(A.YawlowerLim)]); 
       end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    A.Optimiere_Koordinaten=true; %Optimise Layout

    if A.Optimiere_Koordinaten==true
        A.XYlowerLim=[min(A.vecXTurbines,[],'all');min(A.vecYTurbines,[],'all')]+zeros(2,A.nTurbines);
        A.XYupperLim=[max(A.vecXTurbines,[],'all');max(A.vecYTurbines,[],'all')]+zeros(2,A.nTurbines);
      %If A.nStart==1 choose:
      if A.nStart==1
        A.vecXTurbinesSTART= A.vecXTurbines;
        A.vecYTurbinesSTART= A.vecYTurbines;
        A.matSTART         =[A.vecXTurbinesSTART; A.vecYTurbinesSTART];
      elseif A.nStart>1
      %If A.nStart>1 choose:
        rng('default')
       for i=1:A.nStart
        A.vecXTurbinesSTART(i,:)= A.XYlowerLim(1,1:A.nTurbines) + (A.XYupperLim(1,1:A.nTurbines)-A.XYlowerLim(1,1:A.nTurbines)).*rand(A.nTurbines,1)';
        A.vecYTurbinesSTART(i,:)= A.XYlowerLim(2,1:A.nTurbines) + (A.XYupperLim(2,1:A.nTurbines)-A.XYlowerLim(2,1:A.nTurbines)).*rand(A.nTurbines,1)';
        A.matSTART(:,:,i)       = [A.vecXTurbinesSTART(i,:); A.vecYTurbinesSTART(i,:)];
        end
      end
    end

%% Settings for graphical output:
A.GraphicalOutput=true; %Provide graphical output? (Y/N)
%% Plots
A.plot_Leistungsabfall      = true; %Plot Powerdrop
A.plot_Geschwindigkeitsfeld = true; %Plot Speed conditions for steady state
A.plot_Turbulenzfeld        = true; %Plot Turbulence conditions for steady state
A.plot_Rotor                = true; %Plot Rotorlines into Speed/Turbulence field

if A.GraphicalOutput==true
%%%%%%%%%  Resolution of global wind farm field %%%%%%%%%%%%%%%%%
A.resolution=0.1;
%Points to compute outside the turbines coordinates (in 1/D)
A.Xoffset=[-10,10];
A.Yoffset=[-10,10];
end
end
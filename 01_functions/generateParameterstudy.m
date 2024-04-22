function WP=generateParameterstudy()
%% Erstellt Datenstrukur, 
%% Datenstrukturen mit Inputdaten der Windparks
%% werden zu Feldern dieser Struktur
clear all
% vec=10.^-(1:12); %Number of points
% vec=linspace(10,1000);
% rng default % For reproducibility
% vec=lhsdesign(12,2);
% vec(:,1);
% vec(:,1)=vec(:,1)*12+4;
% vec(:,2)=vec(:,2)*8+4;
% vec1=173:1:354; %Number of points
% vec=vec1-270;
vec1=173:1:354; %Number of points
vec=270-vec1;

% Suche alle Inputdateien
files =dir('02_inputs/WP*.m');
files = {files(~[files.isdir]).name};
files = files(~ismember(files,{'.','..'}));
% Schleife über alle Inputdateien
for k=1:length(files)
    % initialize struct 
    [~,name,~]=fileparts(files{k});
    % Check if result exists and ask user whether to load or not
    % if result file exists: Ask user for Input
   result = extractAfter(name,['WP']);
if exist(['03_results/',result,'.mat'])==2 %file exists
m=input(['Result for ',result,' exists. Do you want to load the results? Y/N [Y]:'],'s');
    if isempty(m)
     m = 'Y';
    end
else
    %display(['Result for ',result,' does not exist. Calculation will be executed!']);
    m='N';
end

if m=='Y'
    
% Load Results
      S=load(['03_results/',result,'.mat']);
   WP.(result)=S.Windpark;
   WP.(result).Calc = false;  
else
    % get handle to blade function
    func=str2func(name);
    tmp=func();
tmp=tmp;
tmp.name=['ValidationAlpha_',num2str(round(vec1(k),0))];
tmp.alpha_grad     = vec(k);        %Winkel des Windes [°]
tmp.alpha          = tmp.alpha_grad*pi/180;
tmp.vecgamma_grad   = vec(k)+zeros(1,tmp.nTurbines);
tmp.vecgamma        = deg2rad(tmp.vecgamma_grad);
tmp.vecYaweff_grad = tmp.vecgamma_grad-tmp.alpha_grad;
tmp.vecYaweff      = deg2rad(tmp.vecYaweff_grad);
% tmp.C_Wind=vec(k,1);
% tmp.Ia=vec(k,2);
% tmp.sigmaMIN=vec(k);
% tmp.number_Uc_evaluation=vec(k);
WP.(tmp.name)=tmp;
    end
end
end

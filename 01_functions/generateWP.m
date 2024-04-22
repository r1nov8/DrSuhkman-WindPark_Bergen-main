function WP=generateWP()
%% Builds data structure, 
%% Structure with input data of the wind farm to be modelled

clear all
% Search for all Inputdata
files =dir('02_inputs/WP*.m');
files = {files(~[files.isdir]).name};
files = files(~ismember(files,{'.','..'}));
% Loop over all Inputdata
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
    try
    tmp=func();
tmp=tmp;
WP.(tmp.name)=tmp;
    catch  % If initialisation overfills RAM
    end
end
end
end

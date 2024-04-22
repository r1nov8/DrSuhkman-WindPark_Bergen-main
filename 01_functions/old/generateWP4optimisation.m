function WP=generateWP4optimisation()
%% Erstellt Datenstrukur für die Optimierung von Windparks, 
%% Datenstrukturen mit Inputdaten der Windparks 
%% werden zu Feldern dieser Struktur
clear all
% Suche alle Inputdateien
files =dir('02_inputs/Opti_tmp/WP*.m');
files = {files(~[files.isdir]).name};
files = files(~ismember(files,{'.','..'}));

% initialize struct 
[~,name,~]=fileparts(files);
func=str2func(name);
WP=func();
end


%Script 2 prepare data for Windrose plot (Use Wind Rose Add on)
Windrose=readtable('/Users/kingston/Library/CloudStorage/OneDrive-HøgskulenpåVestlandet/Dokumenter/MATLAB/Bachelor-Havvind/WindPark_Bergen-main/06_Windrose/HR_resolved_AND_altered.txt');
% Windrose=readtable('06_Windrose/HR_resolved_120x22.txt');
v     =table2array(Windrose(:,2));
d   =table2array(Windrose(:,1));
freq   =table2array(Windrose(:,3)).*100000;
Array=[];
for i=1:numel(freq)
reihe=[d(i),v(i)];
for ii=1:freq(i)
Array=[Array; reihe];
end
end
D=Array(:,1);
V=Array(:,2);
%4Reduced
[figure_handle,count,speeds,directions,Table,Others] = WindRose(D,V,'anglenorth',0,'angleeast',90,'labels',{'N (0º)','E (90º)','S (180º)','W (270º)'},'freqlabelangle',45,'ndirections',72,'cmap',inferno);
%4Resolved
%[figure_handle,count,speeds,directions,Table,Others] = WindRose(D,V,'anglenorth',0,'angleeast',90,'labels',{'N (0º)','E (90º)','S (180º)','W (270º)'},'freqlabelangle',45,'ndirections',120, 'vwinds',[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],'cmap',inferno);
colormap=inferno;
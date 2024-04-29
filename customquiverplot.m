% Importer vinddata fra en CSV-fil, hopper over første rad
data = readtable('/Users/kingston/Library/CloudStorage/OneDrive-HøgskulenpåVestlandet/Dokumenter/MATLAB/Bachelor-Havvind/WindPark_Bergen-main/06_Windrose/SummertNORA2019.csv','HeaderLines', 1);

speed = table2array(data(:,2));
angle = table2array(data(:,1));

% Konverter vinkel fra grader til radianer
angle_rad = deg2rad(angle);

% Generate dummy X and Y coordinates if you don't have spatial coordinates
X = 1:length(speed);  % X is a row vector
Y = ones(1, length(speed));  % Y is a row vector

% Your U and V calculations, adjusted for wind coming from the direction
U = speed .* cos(deg2rad(270 - angle));  % Wind direction corrected
V = speed .* sin(deg2rad(270 - angle));  % Wind direction corrected

% Now plot with quiver
quiver(X, Y, U, V, 'AutoScale', 'off');
axis equal;



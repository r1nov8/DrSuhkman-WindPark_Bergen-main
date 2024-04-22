%% Read & Compare data
close all
clear
%% 270
load("03_results\Superpos_Old_222.mat");
PowerOld=Windpark.vecP_Turbines([4 12 20 28 36 44 52 60 68 74])/Windpark.vecP_Turbines(1);
SpeedOld=Windpark.vecUTurbines([4 12 20 28 36 44 52 60 68 74])/Windpark.vecUTurbines(1);
TurbulenceOld=Windpark.vecITurbines([4 12 20 28 36 44 52 60 68 74])/Windpark.vecITurbines(1);
load("03_results\Superpos_New_222.mat");
PowerNew=Windpark.vecP_Turbines([4 12 20 28 36 44 52 60 68 74])/Windpark.vecP_Turbines(1);
SpeedNew=Windpark.vecUTurbines([4 12 20 28 36 44 52 60 68 74])/Windpark.vecUTurbines(1);
TurbulenceNew=Windpark.vecITurbines([4 12 20 28 36 44 52 60 68 74])/Windpark.vecITurbines(1);

% %% 222
load("03_results\Superpos_Old_222.mat");
PowerOld=Windpark.vecP_Turbines([5 12 19 26 33])/Windpark.vecP_Turbines(1);
SpeedOld=Windpark.vecUTurbines([5 12 19 26 33])/Windpark.vecUTurbines(5);
TurbulenceOld=Windpark.vecITurbines([5 12 19 26 33])/Windpark.vecITurbines(5);
load("03_results\Superpos_New_222.mat");
PowerNew=Windpark.vecP_Turbines([5 12 19 26 33])/Windpark.vecP_Turbines(5);
SpeedNew=Windpark.vecUTurbines([5 12 19 26 33])/Windpark.vecUTurbines(5);
TurbulenceNew=Windpark.vecITurbines([5 12 19 26 33])/Windpark.vecITurbines(5);

%% 312
load("03_results\Superpos_Old_312.mat");
PowerOld=Windpark.vecP_Turbines([4 13 22 31 40])/Windpark.vecP_Turbines(1);
SpeedOld=Windpark.vecUTurbines([4 13 22 31 40])/Windpark.vecUTurbines(5);
TurbulenceOld=Windpark.vecITurbines([4 13 22 31 40])/Windpark.vecITurbines(5);
load("03_results\Superpos_New_312.mat");
PowerNew=Windpark.vecP_Turbines([4 13 22 31 40])/Windpark.vecP_Turbines(5);
SpeedNew=Windpark.vecUTurbines([4 13 22 31 40])/Windpark.vecUTurbines(5);
TurbulenceNew=Windpark.vecITurbines([4 13 22 31 40])/Windpark.vecITurbines(5);
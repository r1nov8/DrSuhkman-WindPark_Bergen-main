%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This a tool for analytical 2-D modelling of offshore wind farms                                       %
% - The velocity deficits and rotor added turbulences are modelled using the Ishihara-Qian model (2018) %
% - Wake mixing can be computed with:                                                                   %
%    1) linear rotor added summation by Niayifar & Porté-Agel (2016)                                    %
%    2) momentum conserving superposition by Zong & Porté-Agel (2020)                                   %
% - Wake meandering correction by Braunbehrens & Segalini (2019) can be turned on                       %
%                                                                                                       %
% The flow field between the turbines can be modelled and graphically expressed. Additionally annual    %
% power production - prediction can be performed.                                                       %
% Optimisation using fmincon can be used to find optimal yawangles and turbine positions for both,      %
% single inflow states (direction, wind speed, turbulence) and considering a whole windrose.            %
%                                                                                                       %
% For more information see function comments or contact:                                                %
% 1) Author of the tool:                                                                                %
%    Daniel Sukhman                                                                                     %
%    Email: Daniel.sukhman@gmail.com                                                                    %
%                                                                                                       %
% 2) Supervisors IFAS, TU Braunschweig:                                                                 %
%    M.Sc. Jan Göing/ M.Sc Sebastian Lück                                                               % 
%                                                                                                       %
% 3) Supervisors W3-Wind Water Waves, Høgskulen på Vestlandet                                           %
%    Ph.D Jan Bartl/ Ph.D Thomas Hansen                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

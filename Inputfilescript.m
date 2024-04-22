%Vector 4 Rotorpointstudy & UcPointstudy
%vec=linspace(10,1000)
cd 02_inputs\
for i=1:182
name=['WPRotorpointsstudy',num2str(i),'.m'];
copyfile 'WPRotorpointsstudy.m' xx;
movefile('xx',name);
end
movefile('WPRotorpointsstudy.m','_WPRotorpointsstudy.m');
cd ..
clear all
set(0,'defaultfigurecolor','w')
% Load the trained network
load(['Networks',filesep,'CESTNet_100_100_100_0.01_2643_0.0023771.mat']); 
% Visulize the network
view(net)
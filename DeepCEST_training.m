%% Jianpan Huang, Email: jianpanhuang@outlook.com, 22-Sep-2021
clear all; close all; clc; warning off;
addpath(genpath(pwd));

%% Load data
load(['Data', filesep, 'DeepCEST_TrainData.mat']);

%% Set training parameters
trainFcn = 'trainscg';  % Use the scaled conjugate gradient backpropagation
hiddenLayerSize = [100, 100, 100]; % Number of neurons in hidden layers 
hiddenLayNum = size(hiddenLayerSize,2); % Number of hidden layers 
net = fitnet(hiddenLayerSize,trainFcn); % Create a fitting network
% net = feedforwardnet(hiddenLayerSize,trainFcn);
net.divideFcn = 'dividerand';
% net.divideMode = 'sample';
net.divideParam.trainRatio = 70/100;  % Use 70% of data for training 
net.divideParam.valRatio = 15/100;  % Use 15% of data for validation
net.divideParam.testRatio = 15/100; % Use 15% of data for testing
for nn = 1:hiddenLayNum
    net.layers{nn}.transferFcn = 'tansig';
end
% net.layers{hiddenLayNum+1}.transferFcn = 'purelin';
% net.input.processFcns = {'mapminmax'};
net.output.processFcns = {'mapminmax'};
net.trainParam.show = 50;  % Ephocs in display
net.trainParam.lr = 1e-3;  % Learning rate
net.trainParam.epochs = 1e4;  % Max epochs in total
net.trainParam.goal = 1e-4;  % Training goal
net.trainParam.max_fail = 20; % Max epochs did not show decrease
net.trainParam.min_grad = 1e-5; % Minimum performance gradient
net.performFcn = 'msereg';  % Name of a network performance function
net.performParam.regularization = 0.01; % Regularization gama
net.performParam.normalization = 'percent';% 'none', 'standard', 'percent'  

%% Train the network
[net, tr] = train(net, zInput, pTarget,'useParallel','yes','useGPU','no'); 
% Set to 'yes' if using GPU. In this case, variables should be transformed
% using 'gpuArray' before being fed into network, for example zInput = gpuArray(zInput)

%% Predict
outputs15 = net(zInput(:,tr.testInd),'useParallel','yes','useGPU','no'); % 15% test data
% mse15 = mean((outputs-pTarget(tr.testInd)).^2); % mse of 15% random test data
outputsAll = net(zInput,'useParallel','yes','useGPU','no'); % All test data

%% Plot the results
% Visualization of network
view(net);
% Regression of 15% test data
figure, plotregression(gather(pTarget(3, tr.testInd)), gather(outputs15(3, :)), 'B_0',...
                       gather(pTarget(4, tr.testInd)), gather(outputs15(4, :)), '3.5 ppm',...
                       gather(pTarget(6, tr.testInd)), gather(outputs15(6, :)), 'rNOE',...
                       gather(pTarget(8, tr.testInd)), gather(outputs15(8, :)), 'MT');
% Regression of all test data
figure, plotregression(gather(pTarget(3, :)), gather(outputsAll(3, :)), 'B_0',...
                       gather(pTarget(4, :)), gather(outputsAll(4, :)), '3.5 ppm',...
                       gather(pTarget(6, :)), gather(outputsAll(6, :)), 'rNOE',...
                       gather(pTarget(8, :)), gather(outputsAll(8, :)), 'MT');

%% Save the network
layName = '_';
for nn =1:hiddenLayNum
    layName = [layName, num2str(hiddenLayerSize(nn)),'_'];
end
gamaStr = num2str(net.performParam.regularization);
epochStr = num2str(tr.num_epochs);
vperfStr = tr.best_vperf;
save(['Networks',filesep,'CESTNet', layName, gamaStr,'_', epochStr,'_', vperfStr, '.mat'],'net'); 

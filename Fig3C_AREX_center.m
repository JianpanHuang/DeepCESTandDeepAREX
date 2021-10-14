%% Jianpan Huang, Email: jianpanhuang@outlook.com, 10-July-2021
clear all; close all; clc; warning off;
addpath(genpath(pwd));

%% Load and reorganize Z-spectra
load(['Data', filesep, 'WTdemo.mat']);
zSz = size(zSpec);
paramSz = size(arexPeak);
arexParamNet = zeros(paramSz(1),paramSz(2),paramSz(3),4);
r1Map = 1000./t1Map.*mask; % T1 map to R1 map
counter = 0;
for ss = 1:zSz(3)
    for mm = 1:zSz(1)
        for nn = 1:zSz(2)
            if mask(mm,nn,ss) == 1 
               counter = counter+1;
               zTemp(:,counter) = [squeeze(zSpec(mm,nn,ss,:)); r1Map(mm, nn)]; % Combine Z-spectra with T1
            end
        end   
    end
end
load(['Networks',filesep,'AREXNet_100_100_100_0.01_7496_0.000105.mat']); % The trained network
outputs = net(zTemp); % Feed Z-spectra into the network
counter = 0;
for ss = 1:zSz(3)
    for mm = 1:zSz(1)
        for nn = 1:zSz(2)
            if mask(mm,nn,ss) == 1 
               counter = counter+1;
               arexParamNet(mm,nn,ss,:) = outputs(:,counter); % Restructure into 2D maps
            end
        end
    end
end

%% Display the results
% Find the index of Amide, rNOE and MT
offsAmide = 3.5; % in ppm
[~, indAmide] = min(abs(w-offsAmide));
offsRnoe = -3.5; % in ppm
[~, indRnoe] = min(abs(w-offsRnoe));
offsMt = -2.5;
[~, indMt] = min(abs(w-offsMt));
% Display
dispSz1 = 10:59;
dispSz2 = 15:84; % Remove background and display brain only
caxisVal = [-0.5, 0.5; % deltaB0
             0, 0.16; % 3.5ppm
             0, 0.16; % rNOE
             0, 0.25]; % MT 
set(0,'defaultfigurecolor','w')
for ss = 1:zSz(3)
    scrsz = get(0,'ScreenSize');
    figure1 = figure('Position',[scrsz(3)*0.1 scrsz(4)*0.02 scrsz(3)*0.75 scrsz(4)*1]);
    % deltaB0 map
    subplot(4,3,1), imagesc(cestParam(dispSz1, dispSz2,ss,3).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(1,:)); title('4PLF');
    subplot(4,3,2), imagesc(arexParamNet(dispSz1, dispSz2,ss,1).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(1,:)); title('deepCEST');
    subplot(4,3,3), imagesc((cestParam(dispSz1, dispSz2,ss,3)-arexParamNet(dispSz1, dispSz2,ss,1)).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(1,:)); title('Difference')
    % Amide (3.5 ppm) map
    subplot(4,3,4), imagesc(arexPeak(dispSz1, dispSz2,ss,indAmide,1).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(2,:));
    subplot(4,3,5), imagesc(arexParamNet(dispSz1, dispSz2,ss,2).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(2,:));
    subplot(4,3,6), imagesc((arexPeak(dispSz1, dispSz2,ss,indAmide,1)-arexParamNet(dispSz1, dispSz2,ss,2)).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(2,:));
    % rNOE map
    subplot(4,3,7), imagesc(arexPeak(dispSz1, dispSz2,ss,indRnoe,2).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(3,:));
    subplot(4,3,8), imagesc(arexParamNet(dispSz1, dispSz2,ss,3).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(3,:));
    subplot(4,3,9), imagesc((arexPeak(dispSz1, dispSz2,ss,indRnoe,2)-arexParamNet(dispSz1, dispSz2,ss,3)).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(3,:));
    % MT map
    subplot(4,3,10), imagesc(arexPeak(dispSz1, dispSz2,ss,indMt,3).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(4,:));
    subplot(4,3,11), imagesc(arexParamNet(dispSz1, dispSz2,ss,4).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(4,:));
    subplot(4,3,12), imagesc((arexPeak(dispSz1, dispSz2,ss,indMt,3)-arexParamNet(dispSz1, dispSz2,ss,4)).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(4,:));
    
end

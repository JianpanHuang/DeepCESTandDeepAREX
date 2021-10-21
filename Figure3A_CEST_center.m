%% Jianpan Huang, Email: jianpanhuang@outlook.com, 22-Sep-2021
clear all; close all; clc; warning off;
addpath(genpath(pwd));

%% Load and reorganize Z-spectra
load(['Data', filesep, 'WTdemo.mat']);
zSz = size(zSpec);
paramSz = size(cestParam);
cestParamNet = zeros(paramSz); % CEST parameters prediced by deepCEST
counter = 0;
for ss = 1:zSz(3)
    for mm = 1:zSz(1)
        for nn = 1:zSz(2)
            if mask(mm,nn,ss) == 1 
               counter = counter+1;
               zSpecTemp(:,counter) = squeeze(zSpec(mm,nn,ss,:));
            end
        end   
    end
end

%% Load deepCEST network and predict the CEST parameters
load(['Networks', filesep, 'CESTNet_100_100_100_0.01_2643_0.0023771.mat']); % The trained network
outputs = net(zSpecTemp);  % Feed Z-spectra into the network
counter = 0;
for ss = 1:zSz(3)
    for mm = 1:zSz(1)
        for nn = 1:zSz(2)
            if mask(mm,nn,ss) == 1 
               counter = counter+1; 
               cestParamNet(mm,nn,ss,:) = outputs(:,counter); % Restructure into 2D maps
            end
        end
    end
end

%% Display the results
dispSz1 = 10:59;
dispSz2 = 15:84; % only brain region was displayed wihle background was removed
caxisVal = [-0.5, 0.5; % deltaB0
             0, 0.10; % 3.5ppm
             0, 0.10; % rNOE
             0, 0.15]; % MT 
set(0,'defaultfigurecolor','w') 
for ss = 1:zSz(3)
    scrsz = get(0,'ScreenSize');
    figure1 = figure('Position',[scrsz(3)*0.1 scrsz(4)*0.02 scrsz(3)*0.75 scrsz(4)*1]);
    % deltaB0 map
    subplot(4,3,1), imagesc(cestParam(dispSz1, dispSz2, ss,3).*mask(dispSz1, dispSz2,:,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(1,:)); title('4PLF')
    subplot(4,3,2), imagesc(cestParamNet(dispSz1, dispSz2, ss,3).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(1,:)); title('deepCEST')
    subplot(4,3,3), imagesc((cestParam(dispSz1, dispSz2,ss,3)-cestParamNet(dispSz1, dispSz2, ss,3)).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(1,:)); title('Difference')
    % Amide (3.5 ppm) map
    subplot(4,3,4), imagesc(cestParam(dispSz1, dispSz2, ss,4).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(2,:));
    subplot(4,3,5), imagesc(cestParamNet(dispSz1, dispSz2, ss,4).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(2,:));
    subplot(4,3,6), imagesc((cestParam(dispSz1, dispSz2, ss,4)-cestParamNet(dispSz1, dispSz2, ss,4)).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(2,:));
    % rNOE map
    subplot(4,3,7), imagesc(cestParam(dispSz1, dispSz2, ss,6).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(3,:));
    subplot(4,3,8), imagesc(cestParamNet(dispSz1, dispSz2, ss,6).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(3,:));
    subplot(4,3,9), imagesc((cestParam(dispSz1, dispSz2, ss,6)-cestParamNet(dispSz1, dispSz2, ss,6)).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(3,:));
    % MT map
    subplot(4,3,10), imagesc(cestParam(dispSz1, dispSz2, ss,8).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(4,:));
    subplot(4,3,11), imagesc(cestParamNet(dispSz1, dispSz2, ss,8).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(4,:));
    subplot(4,3,12), imagesc((cestParam(dispSz1, dispSz2, ss,8)-cestParamNet(dispSz1, dispSz2, ss,8)).*mask(dispSz1, dispSz2, :,ss)); mycolormap(2);colorbar;axis off;caxis(caxisVal(4,:));
end

function mycolormap(choice)
%%%%%%%%%%%%%% 保存colormap颜色模式 %%%%%%%%%%%%%
% mycmap = colormap(h);          % gcf为当前图文件的控制句柄
% save('MyColormaps','mycmap');  % 保存颜色模式到本地文件"MyColormaps",MAT-file。
 
%%%%%%%%%%%%%% 调用colormap颜色模式 %%%%%%%%%%%%%
if nargin == 0
    choice = 1;
end
switch choice
    case 1
        load('MyColormaps1','mycmap'); % 将此颜色模式载入当前的workspace,存入一个名叫mycmap的变量矩阵之中；
    case 2
        load('MyColormaps2','mycmap');
     case 3
        load('MyColormaps3','mycmap');
end
colormap(gca,mycmap); % 将mycmap对应的变量矩阵应用到gcf对应的图片中；
end
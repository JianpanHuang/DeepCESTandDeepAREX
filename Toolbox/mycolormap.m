function mycolormap(choice)
%%%%%%%%%%%%%% ����colormap��ɫģʽ %%%%%%%%%%%%%
% mycmap = colormap(h);          % gcfΪ��ǰͼ�ļ��Ŀ��ƾ��
% save('MyColormaps','mycmap');  % ������ɫģʽ�������ļ�"MyColormaps",MAT-file��
 
%%%%%%%%%%%%%% ����colormap��ɫģʽ %%%%%%%%%%%%%
if nargin == 0
    choice = 1;
end
switch choice
    case 1
        load('MyColormaps1','mycmap'); % ������ɫģʽ���뵱ǰ��workspace,����һ������mycmap�ı�������֮�У�
    case 2
        load('MyColormaps2','mycmap');
     case 3
        load('MyColormaps3','mycmap');
end
colormap(gca,mycmap); % ��mycmap��Ӧ�ı�������Ӧ�õ�gcf��Ӧ��ͼƬ�У�
end
function [I,data] = imgDatapol2cart(img,d,sita)
%IMGDATAPOL2CART - 图片极坐标转笛卡尔坐标
%   此函数返回图片I，它是图片img的笛卡尔坐标还原
%
%   I = IMGDATAPOL2CART(img,d) 以径向参数d进行笛卡尔坐标还原
%   I = IMGDATAPOL2CART(img,...,'Name','Value') 自定义角向参数并进行笛卡尔坐标还原
%
%   输入参数
%       img - 输入图像
%           double
%       d - 径向参数(pixel)
%           double | [1,100](默认值)
%
%   名称-值参数
%       derta - 角向精度(rad)
%           double | 2*pi/256(默认值)
%       edge - 柱坐标循环边条余量(rad)
%           double | pi/2(默认值)
%
%   输出参数
%       I - 输出笛卡尔坐标还原图像
%           double
%
%   另请参阅
%
%MATLAB2022b - 2023.5.15 - by SZU-IPC
    arguments
        img % 图片
        d (1,2) double {mustBePositive} = [1,160] % 转换半径(pixel)
        sita.derta (1,1) double {mustBePositive} = 2*pi/256 % 角向精度(rad)
        sita.edge (1,1) double {mustBePositive} = pi/2 % 柱坐标边界余量(rad)
    end
    %% 转换坐标
    img = img(end-d(2)+1:end-d(1)+1,:);
    D = floor(sita.edge/sita.derta);
    pd = makedist('Normal','mu',0,'sigma',D);
    ff = ones(height(img),1)*cdf(pd,-D:D);
    img(:,1:2*D+1) = img(:,1:2*D+1).*ff + img(:,end-2*D:end).*(1-ff);
    img(:,end-2*D:end) = flip(img(:,1:2*D+1),2);
    [theta,rou] = meshgrid(-sita.edge:(2*pi+2*sita.edge)/(width(img)-1):2*pi+sita.edge,d(1):d(2));
    [x,y] = meshgrid(-d(2):d(2),-d(2):d(2));
    r = sqrt(x.^2+y.^2)>=d(1)&sqrt(x.^2+y.^2)<=d(2);
    x = x(r>0);
    y = y(r>0);
    [thetaq,rouq] = cart2pol(x,y);
    thetaq = thetaq+sita.edge;
    img = flip(img);
    I = interp2(theta,rou,img,thetaq,rouq,"linear",nan);
    data.x = x;
    data.y = y;
    data.I = I;
    x = x-min(x)+1;
    y = y-min(y)+1;
    temp = [];
    for i = 1:numel(x)
        temp(x(i),y(i)) = I(i);
    end
    I = flip(temp,2);
end
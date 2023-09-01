function I = imgDatacart2pol(img,w,d,sita)
%IMGDATACART2POL - 图片笛卡尔坐标系转极坐标
%   此函数返回图片I，它是图片img以w为中心的极坐标展开
%
%   I = IMGDATACART2POL(img,w) 计算图像img以w为中心的极坐标展开
%   I = IMGDATACART2POL(img,w,d) 以径向参数d进行极坐标展开
%   I = IMGDATACART2POL(img,...,'Name','Value') 自定义角向参数并进行极坐标展开
%
%   输入参数
%       img - 输入图像
%           double
%       w - 极坐标中心坐标
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
%       I - 输出极坐标展开图像
%           double
%
%   另请参阅
%
%MATLAB2022b - 2023.5.12 - by SZU-IPC
    arguments
        img % 图片
        w (1,2) double {mustBeNonnegative} % 极坐标中心
        d (1,2) double {mustBeNonnegative} = [1,100] % 转换半径(pixel)
        sita.derta (1,1) double {mustBePositive} = 2*pi/256 % 角向精度(rad)
        sita.edge (1,1) double {mustBeNonnegative} = pi/2 % 柱坐标边界余量(rad)
    end
    [theta,rou] = meshgrid(-sita.edge:sita.derta:2*pi+sita.edge,d(1):d(2));
    [xq,yq] = pol2cart(theta,rou);
    [x,y] = meshgrid(1:width(img),1:height(img));
    xqt = xq+w(2);
    yqt = yq+w(1);
    I = interp2(x,y,img,xqt,yqt,"linear",nan); % 插值
    I = flip(I,1);
end
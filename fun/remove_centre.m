function [mask] = remove_centre(I)
%REMOVE_CENTRE - 获取图像目标区域掩膜
%   此函数返回掩膜mask，它是图像I目标区域的掩膜
%
%   [mask] = REMOVE_CENTRE(I) 计算图像I目标区域的掩膜
%
%   输入参数
%       I - 输入图像
%           unit8
%
%   输出参数
%       mask - 目标区域的掩膜
%           double
%   
%   另请参阅 
%
%MATLAB2022b - 2023.5.11 - by SZU-IPC
particle_region=regionprops(im2bw(I,1/255));
boundingBox = particle_region.BoundingBox;
num = size(I,1);
mask = zeros(num, num);
x = ceil(boundingBox(1,2));
y = ceil(boundingBox(1,1));
x_legend = ceil(boundingBox(1,4));
y_legend = ceil(boundingBox(1,3));
mask((num-x_legend)/2:(num-x_legend)/2 + x_legend, (num-y_legend)/2:(num-y_legend)/2 + y_legend)...
    = I(x:x + x_legend, y:y + y_legend);
end


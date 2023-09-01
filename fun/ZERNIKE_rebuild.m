function [g] = ZERNIKE_rebuild(f, order, Tangle, FPZM, VPZM, R, lamda)
%ZERNIKE_rebuild - 计算图片ZERNIKE融合重建
%   此函数返回ZERNIKE融合重建图片g
%   
%   [g] = ZERNIKE_rebuild(f,order,Tangle,FPZM,VPZM,R,lamda)
%   计算ZERNIKE融合重建图片g
%
%   输入参数
%       f - 输入图像
%           unit8
%       order - 最大矩阶
%           double
%       Tangle - ZERNIKE角系数
%           double
%       FPZM - ZERNIKE系数(实部)
%           double
%       VPZM - ZERNIKE系数(虚部)
%           double
%       R - ZERNIKE径向系数
%           double
%       lamda - 融合加权系数
%           double
%   
%   输出参数
%       g - 融合后图片
%           double
%
%   另请参阅
%
%MATLAB2022b - 2023.5.11 - by SZU-IPC
    [Height,Width] = size(f);
    g = zeros(Height,Width);
    %将zernike系数 (FPZM和VPZM) 与一系列分解的正交基 (R) 相乘，组合恢复成新的图像
    for q = 0 : order
        for p = q : 2 : order
            if(q == 0)
                g = g + lamda(1,1) * FPZM(p + 1,q + 1) * R(:,:,p + 1,q + 1) + ...
                lamda(1,2) * FPZM(p + 1,order + q + 2) * R(:,:,p + 1,order + q + 2) + ...
                lamda(1,3) * FPZM(p + 1,2 * order + q + 3) * R(:,:,p + 1,2 * order + q + 3);
            else
                g = g + lamda(1,1)*2*(FPZM(p + 1,q + 1) * cos(q * Tangle) - VPZM(p + 1,q + 1) * sin(q * Tangle)) .* R(:,:,p + 1,q + 1)...
                     + lamda(1,2)*2*(FPZM(p + 1,order + q + 2) * cos(q * Tangle) - VPZM(p + 1,order + q + 2) * sin(q * Tangle)) .* R(:,:,p + 1,order + q + 2)...
                     + lamda(1,3)*2*(FPZM(p + 1,2*order + q + 3) * cos(q * Tangle) - VPZM(p + 1,2*order + q + 3) * sin(q * Tangle)) .* R(:,:,p + 1,2*order + q + 3);
            end
        end
    end
end


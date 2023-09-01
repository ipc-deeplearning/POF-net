function [Tangle,R,FPZM,VPZM] = ZERNIKE_feature(f, order)
%ZERNIKE_feaeture - 计算图片ZERNIKE展开
%   此函数返回ZERNIKE角系数Tangle,ZERNIKE径向系数R,ZERNIKE系数(实部)FPZM,
%   ZERNIKE系数(虚部)VPZM
%   
%   [Tangle,R,FPZM,VPZM] = ZERNIKE_feature(f,order) 计算图片f的order阶
%                                                   ZERNIKE展开
%
%   输入参数
%       f - 输入图像
%           unit8
%       order - 最大矩阶
%           double
%   
%   输出参数
%       Tangle - ZERNIKE角系数
%           double
%       R - ZERNIKE径向系数
%           double
%       FPZM - ZERNIKE系数(实部)
%           double
%       VPZM - ZERNIKE系数(虚部)
%           double
%
%   另请参阅
%
%MATLAB2022b - 2023.5.11 - by SZU-IPC
    f = double(f);
    [Height,Width] = size(f);
    ff=f;
    for i = 0 : Height - 1
        f(i+1,:)=ff(Height-i,:,1);
    end
    c1 = sqrt(2) / (Width - 1);
    c2 = - 1 / sqrt(2);
    for i = 0 : Height - 1
        for j = 0 : Width - 1
            r(i + 1,j + 1) = sqrt((c1 * i + c2) ^ 2 + (c1 * j + c2) ^ 2);
            Tangle(i + 1,j + 1) = atan2((c1 * i + c2),(c1 * j + c2) );
        end
    end
    R=zeros(Height,Width,order+1,order+1);
    for m = 0 : order
        for n = m : 2 : order
            if(n==m)
                R(:,:,n + 1,m + 1) = r .^ m;
            elseif(n==(m + 2))
                R(:,:,n + 1,m + 1) = n * r .^ n - (n - 1) * r .^ (n-2) ;
            else
                K1 = (n + m) * (n - m) * (n - 2) / 2;
                K2 = 2 * n * (n - 1) * (n - 2);
                K3 = -(n - 1) * (m ^ 2 + n * (n - 2));
                K4 = -n * (n + m - 2) * (n - m - 2)/ 2;
			    R(:,:,n + 1,m + 1) = ((K2 * r .^ 2 + K3) .* R(:,:,n-1,m + 1) + K4 * R(:,:,n-3,m + 1)) / K1;
            end
        end
    end 
    FPZM = zeros(order + 1,order + 1);
    VPZM = zeros(order + 1,order + 1);
    for j = 0 : order
        for i = j : 2 : order
            coefficient = 2 * (i + 1) / (pi * (Width - 1) ^ 2);
                temp_M = coefficient * cos(j * Tangle) .* R(:,:,i + 1,j + 1);
                temp_M = f .*temp_M;
                FPZM(i+1,j+1) = sum(temp_M(:));     %计算zernike系数（实部）
                temp_M = coefficient * sin(j * Tangle) .* R(:,:,i + 1,j + 1);
                temp_M = f .*temp_M;
                VPZM(i+1,j+1) = sum(temp_M(:));     %计算zernike系数（虚部）
        end
    end
end


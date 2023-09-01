function U = diff_fun(I,z,pixelsize,light)
%DIFF_FUN - 计算衍射全息图
%   此函数返回图像U，它是图像I在光源light下于记录z处的衍射图像
%
%   U = DIFF_FUN(I) 计算图像I的衍射全息图
%   U = DIFF_FUN(I,z) 计算图像I在距离z处的衍射全息图
%   U = DIFF_FUN(I,z,pixelsize) 计算像素大小为pixelsize的图像I在距离z处的
%                               衍射全息图
%   U = DIFF_FUN(I,...,'Name','Value') 使用自定义光源计算图像I的衍射全息图
%
%   输入参数
%       I - 输入图像
%           double
%       z - 衍射距离(m)
%           double | 3*10^(-3)(默认值)
%       pixelsize - 像素大小(m)
%           double | 1.85*10^(-6)(默认值)
%
%   名称-值参数
%       FWHM - 光源频谱半高全线宽(m)
%           double | 10*10(-9)(默认值) | 0(相干光源)
%       lamda - 光源中心波长(m)
%           double | 0.532*10^(-6)(默认值)
%
%   输出参数
%       U - 衍射全息图
%           double
%   
%   另请参阅 
%
%MATLAB2022b - 2023.4.25 - by SZU-IPC
    arguments
        I % 输入图像
        z (1,:) = 3*10^(-3) % 衍射距离(m)
        pixelsize (1,:) {mustBePositive} = 1.85*10^(-6) % 像素大小(m)
        light.FWHM (1,:) = 10*10^(-9) % 半高宽(m)
        light.lamda (1,:) {mustBePositive} = 0.532*10^(-6) % 中心波长(m)
    end
    FWHM = light.FWHM;
    lamda = light.lamda;
    [M,N]=size(I);
    pixelnumx=N;
    pixelnumy=M;
    deltafx=1/M/pixelsize;
    deltafy=1/N/pixelsize;
    Lx=pixelnumx*pixelsize;
    Ly=pixelnumy*pixelsize;
    xarray=1:pixelnumx;
    yarray=1:pixelnumy;
    [xgrid,ygrid]=meshgrid(xarray,yarray);
    if FWHM == 0
        prop=exp(2*1i*pi*abs(z)*((1/lamda)^2-((xgrid-pixelnumx/2-1).*deltafx).^2-((ygrid-pixelnumy/2-1).*deltafy).^2).^0.5);   
        prop_fft = fftshift(fft2(fftshift(I)));
        if z>0
            U = fftshift(ifft2(fftshift(prop_fft.*prop)));
        else
            U = fftshift(ifft2(fftshift(prop_fft./prop)));
        end
    else
        sigma = FWHM/2*sqrt(2*log(2));
        x = (lamda-3*sigma):10^(-9):(lamda+3*sigma);
        G = Gaussian((10^9)*x,(10^9)*lamda,(10^9)*sigma);
        for i = 1:numel(x)
            prop=exp(2*1i*pi*abs(z)*((1/x(i))^2-((xgrid-pixelnumx/2-1).*deltafx).^2-((ygrid-pixelnumy/2-1).*deltafy).^2).^0.5);   
            prop_fft = fftshift(fft2(fftshift(I*G(i))));
            if z>0
                U{i} = fftshift(ifft2(fftshift(prop_fft.*prop)));
            else
                U{i} = fftshift(ifft2(fftshift(prop_fft./prop)));
            end
        end
        U = sum(abs(cat(3,U{:})),3);
    end
end
function [y] = Gaussian(x,mu,sigma)
    y = (1/(sqrt(2*pi)*sigma))*exp(-(x-mu).^2/(2*sigma^2));
end

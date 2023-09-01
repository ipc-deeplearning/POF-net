function [C,W]=DetectbyPattern(I,T,par)
%DETECTBYPATTERN - 使用模板匹配检测目标
%   此函数返回目标图像T的位置信息，它是目标图像T在图像I中的模板匹配结果
%
%   C = DETECTBYPATTERN(I,T) 计算目标图像T的中心位置
%   [C,W] = DETECTBYPATTERN(I,T) 计算目标图像T的中心位置与指数
%   [C,W] = DETECTBYPATTERN(...,'Name','Value') 使用自定义参数计算图像T的检测结果
%
%   输入参数
%       I - 检测图片
%           double/unit8
%       T - 目标图像
%           double/unit8
%
%   名称-值参数
%
%   输出参数
%       C - 目标中心
%           double
%       W - 目标指数
%           double
%   
%   另请参阅 
%
%MATLAB2022b - 2023.6.7 - by SZU-IPC
%%
    arguments
        I % 检测图像
        T % 目标图像
        par.detectNum (1,1) {mustBePositive} = 10 % 目标个数
    end
%%
    Is = I;
    for i = 1:size(Is,3)
        I = Is(:,:,i);
        % 调整图像尺寸
        T = single(T);
        I = single(I);
        [ri, ci]= size(I);
        [rt, ct]= size(T);
        rmod = 2^nextpow2(rt + ri);
        cmod = 2^nextpow2(ct + ci);
        Tp = zeros(rmod,cmod,'single');
        Ip = zeros(rmod,cmod,'single');
        Tp(1:rt,1:ct) = T;
        Ip(1:ri,1:ci) = I;
        % 互相关计算
        Tfft = fft2(Tp);
        Ifft = fft2(Ip);
        corr_freq = Ifft .* Tfft;
        corrOutput_f = ifft2(corr_freq);
        corrOutput_f = corrOutput_f(rt:ri, ct:ci);
        % 归一化
        IUT = conv2(I.^2, ones(rt, ct, 'single'), 'valid');
        norm_Corr_f = corrOutput_f ./ (IUT * sqrt(sum(T(:).^2)));
        norm_Corr_f = (norm_Corr_f - min(norm_Corr_f,[],'all'))./...
            (max(norm_Corr_f,[],'all') - min(norm_Corr_f,[],'all'));
        % 寻找局部极大位置
        threshold = graythresh(norm_Corr_f);
        LMaxFinder = vision.LocalMaximaFinder(par.detectNum,[41,41],'Threshold',threshold);
        xyLocation = LMaxFinder(norm_Corr_f);
        % 输出
        W{i} = norm_Corr_f(sub2ind(size(norm_Corr_f),...
            xyLocation(:,2),xyLocation(:,1)));
        C{i} = xyLocation + uint32(ones(height(xyLocation),1)*(floor(size(T)/2)+1));
        C{i} = double(C{i});
    end
end
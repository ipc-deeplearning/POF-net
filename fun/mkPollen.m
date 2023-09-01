function mkPollen(N,path,savepath,order,n)
%MKPOLLEN - 融合生成新的花粉样本
%   此函数融合生成新的花粉样本，并保存在对应目录下
%
%   MKPOLLEN 使用默认参数融合生成保存新的花粉样本
%   MKPOLLEN(N) 每种花粉样本生成N个并保存
%   MKPOLLEN(N,path,savepath) 自定义原始图像来源与存储路径
%   MKPOLLEN(N,path,savepath,order,n) 自定义Zernike矩参数
%
%   输入参数
%       N - 每种花粉颗粒生成样本数
%           double | 10(默认值)
%       path - 标准花粉颗粒存储路径
%           char | './data/pollen(standard)'(默认值)
%       savepath - 生成数据存储路径
%           char | './data/pollen(mk)'(默认值)
%       order - Zernike矩最大阶数
%           double | 60(默认值)
%       n - 用于融合的图片数
%           double | 3(默认值)
%
%   另请参考
%
%MATLAB2022b - 2023.5.11 - by SZU-IPC
    arguments
        N (1,1) {mustBePositive} =10; % 每种花粉颗粒生成样本数
        path = './data/pollen(standard)'; % 标准花粉颗粒存储路径
        savepath = './data/pollen(mk)'; % 生成数据存储路径
        order (1,1) {mustBePositive} =60; % Zernike矩最大阶数
        n (1,1) {mustBeLessThan(n,10)} = 3; % 用于融合的图片数
    end
    % 数据准备
    mkdir(savepath);
    paths = dir(path);
    % 按类别生成花粉图样
    for i = 3:numel(paths)
        mkdir([savepath,'/',paths(i).name])
        picpath = dir([path,'/',paths(i).name,'/*.png']);
        % Zernike分解
        for j = 1:numel(picpath)
            I{j} = imread([picpath(j).folder,'/',picpath(j).name]);
            Img = remove_centre(I{j});
            [T{j},R{j},F{j},V{j}] = ZERNIKE_feature(uint8(Img), order);
        end
        % Zernike融合
        for j = 1:N
            w = randperm(10);
            r = cat(4,R{1:n});
            f = cat(2,F{1:n});
            v = cat(2,V{1:n});
            lamda = rand(1,n);
            lamda = lamda/sum(lamda);
            g = ZERNIKE_rebuild(I{n}, order, T{n}, f, v, r, lamda);
            g = max(g,0.0);
            g = mat2gray(g)>0.1;
            g = imrotate(g,360*rand(1));
            imwrite(g,[savepath,'/',...
                paths(i).name,'/',num2str(j,'%03d'),'.png'])
        end
    end
end
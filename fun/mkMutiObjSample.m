function [wphy,I,O] = mkMutiObjSample(path,pollen_path,Size,t,obj,nos)
%MKMUTIOBJSAMPLE - 生成多颗粒非相干叠加全息图视频数据
%   此函数返回视频流参数结构体wphy单颗粒独立图片I以及总图片O，它是视野大小为Size，
%   时长为t，目标参数为obj，噪声参数为nos的模拟数据
%
%   MKMUTIOBJSAMPLE(path) 生成模拟数据，并保存在路径path中
%   MKMUTIOBJSAMPLE(path,pollen_path) 使用pollen_path下的模拟颗粒样本生成模拟数据
%   [wphy,I,O] = MKMUTIOBJSAMPLE(path,pollen_path,Size,t) 设置模拟视野为Size，
%   时长为t的模拟数据，并返回参数与图像数据
%   wphy = MKMUTIOBJSAMPLE(path,...,'Name','Value') 自定义模拟颗粒与噪声的参数
%
%   输入参数
%       path - 保存路径
%           char
%       pollen_path - 花粉颗粒路径
%           char | './data/pollen(mk)'(默认值)
%       Size - 视野大小(pixel)
%           double | [600,600](默认值)
%       t - 视频流长度(帧)
%           double | 100(默认值)
%
%   名称-值参数
%       N - 目标颗粒数目
%           double | 9(默认值)
%       R - 颗粒大小(pixel)
%           double | [0,0](0为使用花粉)
%       V - 颗粒平面速度(pixel/frame)
%           double | [0.1,2](默认值)
%       Vd - 深度速度(um/frame)
%           double | [0,10](默认值)
%       D - 深度范围(um)
%           double | [3400,3600](默认值)
%       Nn - 杂质粒子数量
%           double | 100(默认值)
%       Rn - 杂质颗粒大小(pixel)
%           double | [0.5,1](默认值)
%       Vn - 杂质速度(pixel/frame)
%           double | [0,3](默认值)
%       Dn - 杂质深度范围(um)
%           double | [1000,5000](默认值)
%
%   输出参数
%       wphy - 参数结构体
%           struct
%       I - 单个颗粒图像
%           cell
%       O - 整体图像
%           cell
%   
%   另请参阅 
%
%MATLAB2022b - 2023.5.11 - by SZU-IPC
    arguments
        path % 路径
        pollen_path = './data/pollen(mk)'; % 花粉路径
        Size (1,2) double {mustBePositive} = [600,600]; % 计算区域大小(pixel)
        t (1,1) double {mustBePositive} = 100; % 帧数
        obj.N (1,1) double {mustBePositive} = 9; % 颗粒数目
        obj.R (1,2) double {mustBeNonnegative} = [0,0]; % 颗粒大小(0为使用花粉)(pixel)
        obj.V (1,2) double {mustBePositive} = [0.1,2]; % 颗粒平面速度(pixel/frame)
        obj.Vd (1,2) double {mustBeNonnegative} = [0,10]; % 深度速度(um/frame)
        obj.D (1,2) double {mustBePositive} = [3400,3600]; % 深度范围(um)
        nos.Nn (1,1) double {mustBePositive} = Size(1)*Size(2)/(60*60); % 杂质粒子数量
        nos.Rn (1,2) double {mustBePositive} = [0.5,1]; % 杂质颗粒大小(pixel)
        nos.Vn (1,2) double {mustBeNonnegative} = [0,3]; % 杂质速度(pixel/frame)
        nos.Dn (1,2) double {mustBePositive} = [1000,5000]; % 杂质深度范围
    end
    %% 空间分布
    N = obj.N;
    R = obj.R;
    V = obj.V;
    Vd = obj.Vd;
    D = obj.D;
    Nn = nos.Nn;
    Rn = nos.Rn;
    Vn = nos.Vn;
    Dn = nos.Dn;
    %% 目标粒子
    % x方向
    wphy.x = randsrc(1,N,200:Size(1)-200);
    tempv = randsrc(1,N,V(1):0.1:V(2)).*randsrc(1,N,[-1,1])/4;
    for i = 1:t/2
        wphy.x = [wphy.x(1,:)-tempv;wphy.x];
        wphy.x = [wphy.x;wphy.x(end,:)+tempv];
    end
    wphy.x(end,:) = [];
    % y方向
    wphy.y = randsrc(1,N,200:Size(2)-200);
    tempv = randsrc(1,N,V(1):0.1:V(2)).*randsrc(1,N,[-1,1]);
    for i = 1:t/2
        wphy.y = [wphy.y(1,:)-tempv;wphy.y];
        wphy.y = [wphy.y;wphy.y(end,:)+tempv];
    end
    wphy.y(end,:) = [];
    % z方向
    wphy.z = randsrc(1,N,D(1):D(2));
    tempv = randsrc(1,N,Vd(1):Vd(2)).*randsrc(1,N,[-1,1]);
    for i = 1:t/2
        wphy.z = [wphy.z(1,:)-tempv;wphy.z];
        wphy.z = [wphy.z;wphy.z(end,:)+tempv];
    end
    wphy.z(end,:) = [];
    % R
    if sum(R) ~= 0
        wphy.r = randsrc(1,N,R(1):0.1:R(2));
    else
        paths = dir([pollen_path,'/pine/*.png']);
        for i = 1:N
            wphy.r{i} = imread([paths(randsrc(1,1,1:numel(paths))).folder,...
                '/',paths(randsrc(1,1,1:numel(paths))).name]);
        end
    end
    %% 杂质粒子
    % x方向
    nn.x = randsrc(1,Nn,1:Size(1));
    tempv = randsrc(1,Nn,Vn(1):Vn(2)).*randsrc(1,Nn,[-1,1]);
    for i = 1:t/2
        nn.x = [nn.x(1,:)-tempv;nn.x];
        nn.x = [nn.x;nn.x(end,:)+tempv];
    end
    nn.x(end,:) = [];
    % y方向
    nn.y = randsrc(1,Nn,-Size(2)/2:3*Size(2)/2);
    tempv = randsrc(1,Nn,Vn(1):Vn(2));
    for i = 1:t/2
        nn.y = [nn.y(1,:)-tempv;nn.y];
        nn.y = [nn.y;nn.y(end,:)+tempv];
    end
    nn.y(end,:) = [];
    % z方向
    nn.z = randsrc(1,Nn,Dn(1):Dn(2));
    % R
    nn.r = randsrc(1,Nn,Rn(1):0.1:Rn(2));
    %% 生成图像
    I = cell(t,N,2); % 单颗粒
    O = cell(t,1); % 全图像
    d = 100; % 图像边缘(不可使用区域)
    % 目标颗粒
    for i = 1:t
        for j = 1:N
            X = wphy.x(i,j);
            Y = wphy.y(i,j);
            Z = wphy.z(i,j);
            r = wphy.r(j);
            if sum(R) ~= 0
                [x,y] = meshgrid(1:Size(1)+2*d,1:Size(2)+2*d);
                I{i,j,1} = sqrt((x-X-d).^2+(y-Y-d).^2)>r;
            else 
                I{i,j,1} = ones(Size(1)+2*d,Size(2)+2*d);
                [mx,my] = find(r{1}>0);
                mx = floor(X-(floor(height(r{1})/2)+2-mx)+d); % 区域中位置
                my = floor(Y-(floor(width(r{1})/2)+2-my)+d);
                w = (mx<1|mx>(Size(1)+2*d)|my<1|my>(Size(2)+2*d));
                mx(w) = [];
                my(w) = [];
                for k = 1:numel(mx)
                    I{i,j,1}(mx(k),my(k)) = 0;
                end
            end
            I{i,j,2} = abs(diff_fun(I{i,j,1},Z*10^(-6)));
            I{i,j,1} = I{i,j,1}((d+1):(Size(1)+d),(d+1):(Size(2)+d));
            I{i,j,2} = I{i,j,2}((d+1):(Size(1)+d),(d+1):(Size(2)+d));
        end
        %O{i} = sum(cat(3,I{i,:,2}),3)-N+1;
        % 添加杂质粒子     
        In = cell(Nn,1);
        for j = 1:Nn
            [x,y] = meshgrid(1:Size(1)+2*d,1:Size(2)+2*d);
            X = nn.x(i,j);
            Y = nn.y(i,j);
            Z = nn.z(j);
            r = nn.r(j);
            In{j} = sqrt((x-X-d).^2+(y-Y-d).^2)>r;
            In{j} = abs(diff_fun(In{j},Z*10^(-6)));
            In{j} = In{j}((d+1):(Size(1)+d),(d+1):(Size(2)+d));
        end
        %IN = sum(cat(3,In{:}),3)-Nn+1; % 粒子噪声图
        %O{i} = O{i}+IN-1;
        %O{i} = sum(cat(3,cat(3,I{i,:,2}),cat(3,In{:})),3)/(N+Nn);
        %O{i} = (O{i}-min(O{i},[],'all'))/(max(O{i},[],'all')-min(O{i},[],'all'));
        O{i} = cumprod(cat(3,cat(3,I{i,:,2}),cat(3,In{:})),3);
        O{i} = O{i}(:,:,end);
        O{i} = gray_adjust(O{i});
%         O{i} = imnoise(O{i},'gaussian',0.001,0.001); % 添加高斯噪声 
        disp(i)
    end
    %% 保存数据
    mkdir(path)
    mkdir([path,'/shape'])
    mkdir([path,'/HoloSingle'])
    for i = 1:N
        mkdir([path,'/shape/',num2str(i)])
        mkdir([path,'/HoloSingle/',num2str(i)])
    end 
    mkdir([path,'/HoloAll'])
    for i = 1:t
        for j = 1:N
            imwrite(I{i,j,1},[path,'/shape/',num2str(j),'/',num2str(i,'%03d'),'.png']);
            I{i,j,2} = gray_adjust(I{i,j,2});
            imwrite(I{i,j,2},[path,'/HoloSingle/',num2str(j),'/',num2str(i,'%03d'),'.png']);
        end
        imwrite(O{i},[path,'/HoloAll/',num2str(i,'%03d'),'.png'])
    end
    wphy.par.Size = Size;
    wphy.par.N = N;
    wphy.par.R = R;
    wphy.par.V = V;
    wphy.par.Vd = Vd;
    wphy.par.D = D;
    wphy.par.t = t;
    save([path,'/wphy'],'wphy')
end
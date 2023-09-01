function img2flow(path)
%IMG2FLOW - 图片计算光流
%   此函数保存图片对应的光流到数据集对应位置
%
%   IMG2FLOW(path) 处理path对应数据集图片计算其光流，并保存在对应位置
%
%   输入参数
%       path - 数据集路径
%           char
%
%   另请参阅
%
%MATLAB2022b - 2023.5.15 - by SZU-IPC
    arguments
        path % 路径
    end
    opticFlow = opticalFlowLK('NoiseThreshold',0.0005);
    flag = 0;
    %% 读取数据
    load([path,'/wphy.mat']) % 空间信息
    mkdir([path,'/polHolo/flow'])
    for i = 1:wphy.par.N
        if flag
            i = [];
        end
        mkdir([path,'/polHolo/flow/',num2str(i)])
        if flag
            break
        end
    end
    %% 创建视频
    for i = 1:wphy.par.N
        paths = dir([path,'/polHolo/img/',num2str(i),'/*.png']);
        if flag
            paths = dir([path,'/polHolo/img/*.png']);
        end
        v1 = VideoWriter([path,'/polHolo/flow/',num2str(i),'.avi']);
        v2 = VideoWriter([path,'/polHolo/flow/',num2str(i),'-.avi']);
        open(v1)
        open(v2)
        for j = 1:numel(paths)
            img = imread([paths(j).folder,'/',paths(j).name]);
            writeVideo(v1,img);
            img = imread([paths(numel(paths)-j+1).folder,'/',...
                paths(numel(paths)-j+1).name]);
            writeVideo(v2,img);
        end
        close(v1)
        close(v2)
    end
    %% 计算光流
    Flow.I = cell(0,wphy.par.N);
    Flow.Vx = cell(0,wphy.par.N,2);
    Flow.Vy = cell(0,wphy.par.N,2);
    for i = 1:wphy.par.N
        vidReader1 = VideoReader([path,'/polHolo/flow/',num2str(i),'.avi']);
        vidReader2 = VideoReader([path,'/polHolo/flow/',num2str(i),'-.avi']);
        k = 1;
        while hasFrame(vidReader1)
            frame = readFrame(vidReader1);
            frame = rgb2gray(frame);
            flow = estimateFlow(opticFlow,frame);
            Flow.Vx{k,i,1} = flow.Vx./abs(flow.Vx.^2+flow.Vy.^2);
            Flow.Vx{k,i,1}(isnan(Flow.Vx{k,i,1})) = 0;
            Flow.Vy{k,i,1} = flow.Vy./abs(flow.Vx.^2+flow.Vy.^2);
            Flow.Vy{k,i,1}(isnan(Flow.Vy{k,i,1})) = 0;
            Flow.I{k,i} = frame;
            k = k+1;
        end
        k = 1;
        while hasFrame(vidReader2)
            frame = readFrame(vidReader2);
            frame = rgb2gray(frame);
            flow = estimateFlow(opticFlow,frame);
            Flow.Vx{k,i,2} = flow.Vx./abs(flow.Vx.^2+flow.Vy.^2);
            Flow.Vx{k,i,2}(isnan(Flow.Vx{k,i,2})) = 0;
            Flow.Vy{k,i,2} = flow.Vy./abs(flow.Vx.^2+flow.Vy.^2);
            Flow.Vy{k,i,2}(isnan(Flow.Vy{k,i,2})) = 0;
            k = k+1;
        end
        for j = 1:height(Flow.I)
            img = cat(3,im2double(Flow.I{j,i}),...
                abs(Flow.Vx{j,i,1}-Flow.Vx{k-j,i,2})/2,...
                abs(Flow.Vy{j,i,1}-Flow.Vy{k-j,i,2})/2);
            imwrite(img,[path,'/polHolo/flow/',num2str(i),'/',num2str(j,'%03d'),'.png'])
        end
        if flag
            break
        end
    end
    %save([path,'/polHolo/flow/flow'],'Flow')
end
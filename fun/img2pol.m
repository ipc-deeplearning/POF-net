function img2pol(path)
%IMG2POL - 图片转换到极坐标
%   此函数保存对应图像文件的极坐标展开到数据集对应位置
%
%   IMG2POL(path) 处理path对应数据集图片转换极坐标，并保存在对应位置
%
%   输入参数
%       path - 数据集路径
%           char
%
%   另请参阅
%
%MATLAB2022b - 2023.5.12 - by SZU-IPC
    arguments
        path % 路径
    end
    %% 读取数据
    load([path,'/wphy.mat']) % 空间信息
    mkdir([path,'/polHolo'])
    mkdir([path,'/polHolo/img'])
    mkdir([path,'/polHolo/single'])
    mkdir([path,'/polHolo/shape'])
    for i = 1:wphy.par.N
        mkdir([path,'/polHolo/img/',num2str(i)])
        mkdir([path,'/polHolo/single/',num2str(i)])
        mkdir([path,'/polHolo/shape/',num2str(i)])
    end
    %% 转换坐标
    for i = 1:wphy.par.t
        disp(i)
        for j = 1:wphy.par.N
            I = imread([path,'/HoloAll/',num2str(i,'%03d'),'.png']);
            L = imread([path,'/HoloSingle/',num2str(j),'/',...
                num2str(i,'%03d'),'.png']);
            O = imread([path,'/shape/',num2str(j),'/',...
                num2str(i,'%03d'),'.png']);
            I = im2double(I);
            L = im2double(L);
            O = double(O);
            GtI = imgDatacart2pol(I,[wphy.x(i,j),wphy.y(i,j)],[1,160],"derta",1/160);
            GtL = imgDatacart2pol(L,[wphy.x(i,j),wphy.y(i,j)],[1,160],"derta",1/160);
            GtO = imgDatacart2pol(O,[wphy.x(i,j),wphy.y(i,j)],[1,160],"derta",1/160);
            imwrite(GtI,[path,'/polHolo/img/',num2str(j),'/',num2str(i,'%03d'),'.png'])
            imwrite(GtL,[path,'/polHolo/single/',num2str(j),'/',num2str(i,'%03d'),'.png'])
            imwrite(GtO,[path,'/polHolo/shape/',num2str(j),'/',num2str(i,'%03d'),'.png'])
        end
    end
end
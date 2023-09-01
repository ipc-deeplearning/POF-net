function [RMSE,Y,YPred] = testNet(path,netpath,w,flag,Size)
    arguments
        % path:数据路径
        path (1,:) char
        % netpath:网络路径
        netpath
        % w:
        w = [];
        flag = 0;
        % Size.R:图片大小
        Size.R (1,2) double {mustBePositive} = [1,160];
    end
    %% 读取数据
    load([path,'/wphy.mat']) % 空间信息
    if isempty(w)
        mkdir([path,'/polHolo/test'])
        for i = 1:wphy.par.N
            mkdir([path,'/polHolo/test/',num2str(i)])
        end
        load(netpath)
    else
        Net = netpath;
    end
    %% 测试
    RMSE = [];
    if isempty(w)
        for i = 1:wphy.par.N
            imds = imageDatastore([path,'/polHolo/flow/',num2str(i)]);
            imds = readall(imds);
            imds = cat(4,imds{:});
            imds = im2double(imds);
            imds = imresize(imds,Net.Layers(1).InputSize(1:2));
            imds = imds(Size.R(1):Size.R(2),:,:,:);
            YPred = [];
            for j = 1:size(imds,4)
                temp = predict(Net,imds(:,:,:,j));
                YPred = cat(4,YPred,temp);
            end
%             Y = imageDatastore([path,'/polHolo/single/',num2str(i)]);
%             Y = readall(Y);
%             Y = cat(4,Y{:});
%             Y = im2double(Y);
%             Y = imresize(Y,Net.Layers(1).InputSize(1:2));
%             Y = Y(Size.R(1):Size.R(2),:,:,:);
%             RMSE = [RMSE;rmse(YPred,Y,"all")];
            for j = 1:wphy.par.t
                temp = YPred(:,:,:,j);
    %             for k = 1:size(imds,2)
    %                 temp(1:floor(YPred(:,k,:,j)*size(imds,1)),k)=1;
    %             end
                imwrite(temp,[path,'/polHolo/test/',num2str(i),...
                    '/',num2str(j,'%03d'),'.png']);
            end
        end
    else
        if Net.Layers(1).InputSize(3) == 1
            imds = imageDatastore([path,'/polHolo/img'], ...
            'IncludeSubfolders',true);
        else
            imds = imageDatastore([path,'/polHolo/flow'], ...
            'IncludeSubfolders',true);
        end
        imds = readall(imds);
        imds = cat(4,imds{:});
        imds = im2double(imds);
        imds = imresize(imds,Net.Layers(1).InputSize(1:2));
        imds = imds(Size.R(1):Size.R(2),:,:,:);
        imds = imds(:,:,:,w);
        Y = imageDatastore([path,'/polHolo/single'], ...
        'IncludeSubfolders',true);
        Y = readall(Y);
        Y = cat(4,Y{:});
        Y = im2double(Y);
        Y = imresize(Y,Net.Layers(1).InputSize(1:2));
        Y = Y(Size.R(1):Size.R(2),:,:,:);
        Y = Y(:,:,:,w);
        YPred = [];
        if flag == 1
            options = trainingOptions('sgdm', ...
               'InitialLearnRate',eps, ...
               'ResetInputNormalization',false,...
               'OutputFcn',@(~)true );
            Net = trainNetwork(imds(:,:,:,1),Y(:,:,:,1),layerGraph(Net),options);
        end
        for j = 1:size(imds,4)
            temp = predict(Net,imds(:,:,:,j));
            YPred = cat(4,YPred,temp);
        end
        RMSE = rmse(YPred,Y,2:4);
    end
end
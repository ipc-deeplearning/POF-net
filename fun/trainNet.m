%% 训练网络
function [Net,info] = trainNet(path,netpath,savepath,par)
    arguments
        % path:数据路径
        path (1,:) char
        % netpath:网络路径
        netpath
        % savepath:保存路径
        savepath = []
        % par.minibatch:小批量参数
        par.minibatch (1,1) double {mustBePositive} = 1
        % par.numEpochs:迭代次数
        par.numEpochs (1,1) double {mustBePositive} = 10
        % par.learnRate:学习率
        par.learnRate (1,1) double {mustBePositive} = 0.0001
        % par.R:图片大小
        par.R (1,2) double {mustBePositive} = [1,160];
        % par.checkpointPath:监测点路径
        par.checkpointPath char = '';
        % par.system:坐标系
        par.system char = '';
    end
    %% 读取数据
    if ischar(netpath)
        load(netpath);
    else
        Net = netpath;
    end
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
    label = imageDatastore([path,'/polHolo/single'], ...
    'IncludeSubfolders',true);
    label = readall(label);
    label = cat(4,label{:});
    label = im2double(label);
    label = imresize(label,Net.Layers(1).InputSize(1:2));
    W = unidrnd(size(imds,4)-2,100,1)+1;
    Vimds = imds(:,:,:,W);
    Vlabel = label(:,:,:,W);
    %
    imds = imds(:,64:315,:,:);
    label = label(:,64:315,:,:);
    W = unidrnd(251,[size(imds,4),1]);
    for i = 1:size(imds,4)
        imds(:,:,:,i) = [imds(:,W(i)+1:end,:,i),imds(:,1:W(i),:,i)];
        label(:,:,:,i) = [label(:,W(i)+1:end,:,i),label(:,1:W(i),:,i)];
    end
    imds = [imds(:,190:end,:,:),imds,imds(:,1:64,:,:)];
    label = [label(:,190:end,:,:),label,label(:,1:64,:,:)];
    %% 训练参数
    options = trainingOptions('adam', ...
        'InitialLearnRate',par.learnRate, ...
        'MaxEpochs',par.numEpochs, ...
        'Shuffle','every-epoch', ...
        'MiniBatchSize',par.minibatch, ...
        'VerboseFrequency',1, ...
        'CheckpointPath',par.checkpointPath, ...
        'CheckpointFrequencyUnit','iteration', ...
        'CheckpointFrequency',900, ...
        'OutputNetwork','best-validation-loss', ...
        'ValidationData',{Vimds,Vlabel});
    %% 训练
    [Net,info] = trainNetwork(imds,label,Net,options);
    if ~isempty(savepath)
        save([savepath,'.mat'],'Net')
        save([savepath,'_his.mat'],'info')
    end
end
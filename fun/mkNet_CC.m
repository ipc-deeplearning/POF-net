function Net = mkNet_CC(input_size,n)
%MKNET_CC - 生成网络结构
%   此函数返回网络结构Net，它是输入大小为input_size
%
%   Net = MKNET_TC(input_size) 生成CC网络结构
%   Net = MKNET_TC(input_size,n) 生成CC网络结构并保存
%
%   输入参数
%       input_size - 输入大小
%           double
%       n - 保存路径
%           char | ''(不保存)
%
%   输出参数
%       Net - 网络结构
%           LayerGraph
%   
%   另请参阅 
%
%MATLAB2022b - 2023.5.15 - by SZU-IPC
    arguments
        input_size double {mustBePositive}
        n char
    end

    lgraph = layerGraph();
    
    y = input_size(2);

    tempLayers = imageInputLayer(input_size,"Name","data","Normalization","none");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([7 7],y,"Name","conv1","BiasLearnRateFactor",0,"Padding","same","Stride",[2 2])
        batchNormalizationLayer("Name","bn_conv1")
        tanhLayer("Name","conv1_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],y,"Name","res2a_branch2a","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2a_branch2a")
        tanhLayer("Name","res2a_branch2a_relu")
        convolution2dLayer([3 3],y,"Name","res2a_branch2b","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2a_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res2a")
        tanhLayer("Name","res2a_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],y,"Name","res2b_branch2a","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2b_branch2a")
        tanhLayer("Name","res2b_branch2a_relu")
        convolution2dLayer([3 3],y,"Name","res2b_branch2b","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2b_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res2b")
        tanhLayer("Name","res2b_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([1 1],128,"Name","res3a_branch1","BiasLearnRateFactor",0,"Stride",[2 2])
        batchNormalizationLayer("Name","bn3a_branch1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],128,"Name","res3a_branch2a","BiasLearnRateFactor",0,"Padding","same","Stride",[2 2])
        batchNormalizationLayer("Name","bn3a_branch2a")
        tanhLayer("Name","res3a_branch2a_relu")
        convolution2dLayer([3 3],128,"Name","res3a_branch2b","BiasLearnRateFactor",0,"Padding","same")
        batchNormalizationLayer("Name","bn3a_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res3a")
        tanhLayer("Name","res3a_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],128,"Name","res3b_branch2a","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn3b_branch2a")
        tanhLayer("Name","res3b_branch2a_relu")
        convolution2dLayer([3 3],128,"Name","res3b_branch2b","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn3b_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res3b")
        tanhLayer("Name","res3b_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([1 1],256,"Name","res4a_branch1","BiasLearnRateFactor",0,"Stride",[2 2])
        batchNormalizationLayer("Name","bn4a_branch1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],256,"Name","res4a_branch2a","BiasLearnRateFactor",0,"Padding","same","Stride",[2 2])
        batchNormalizationLayer("Name","bn4a_branch2a")
        tanhLayer("Name","res4a_branch2a_relu")
        convolution2dLayer([3 3],256,"Name","res4a_branch2b","BiasLearnRateFactor",0,"Padding","same")
        batchNormalizationLayer("Name","bn4a_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res4a")
        tanhLayer("Name","res4a_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],256,"Name","res4b_branch2a","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn4b_branch2a")
        tanhLayer("Name","res4b_branch2a_relu")
        convolution2dLayer([3 3],256,"Name","res4b_branch2b","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn4b_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res4b")
        tanhLayer("Name","res4b_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([1 1],512,"Name","res5a_branch1","BiasLearnRateFactor",0,"Stride",[2 2])
        batchNormalizationLayer("Name","bn5a_branch1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],512,"Name","res5a_branch2a","BiasLearnRateFactor",0,"Padding","same","Stride",[2 2])
        batchNormalizationLayer("Name","bn5a_branch2a")
        tanhLayer("Name","res5a_branch2a_relu")
        convolution2dLayer([3 3],512,"Name","res5a_branch2b","BiasLearnRateFactor",0,"Padding","same")
        batchNormalizationLayer("Name","bn5a_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res5a")
        tanhLayer("Name","res5a_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],512,"Name","res5b_branch2a","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn5b_branch2a")
        tanhLayer("Name","res5b_branch2a_relu")
        convolution2dLayer([3 3],512,"Name","res5b_branch2b","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn5b_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res5b")
        tanhLayer("Name","res5b_relu")
        transposedConv2dLayer([3 3],256,"Name","transposed-conv","Cropping","same","Stride",[2 2])
        batchNormalizationLayer("Name","batchnorm")
        tanhLayer("Name","relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input_3","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat")
        transposedConv2dLayer([3 3],128,"Name","transposed-conv_1","Cropping","same","Stride",[2 2])
        batchNormalizationLayer("Name","batchnorm_1")
        tanhLayer("Name","relu_1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat_1")
        transposedConv2dLayer([3 3],y,"Name","transposed-conv_2","Cropping","same","Stride",[2 2])
        batchNormalizationLayer("Name","batchnorm_2")
        tanhLayer("Name","relu_2")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input_1","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat_2")
        transposedConv2dLayer([3 3],16,"Name","transposed-conv_3","Cropping","same","Stride",[2 2])
        batchNormalizationLayer("Name","batchnorm_3")
        tanhLayer("Name","relu_3")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input_2","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat_3")
        transposedConv2dLayer([1 1],1,"Name","transposed-conv_4","Cropping","same")
        batchNormalizationLayer("Name","batchnorm_4")
        tanhLayer("Name","relu_4")
        sigmoidLayer("Name","sigmoid")
        regressionLayer("Name","regressionoutput")];
    lgraph = addLayers(lgraph,tempLayers);
    
    % 清理辅助变量
    clear tempLayers;
    
    lgraph = connectLayers(lgraph,"data","conv1");
    lgraph = connectLayers(lgraph,"data","resize-reference-input_2/ref");
    lgraph = connectLayers(lgraph,"data","depthcat_3/in1");
    lgraph = connectLayers(lgraph,"conv1_relu","res2a_branch2a");
    lgraph = connectLayers(lgraph,"conv1_relu","res2a/in2");
    lgraph = connectLayers(lgraph,"bn2a_branch2b","res2a/in1");
    lgraph = connectLayers(lgraph,"res2a_relu","res2b_branch2a");
    lgraph = connectLayers(lgraph,"res2a_relu","res2b/in2");
    lgraph = connectLayers(lgraph,"bn2b_branch2b","res2b/in1");
    lgraph = connectLayers(lgraph,"res2b_relu","res3a_branch1");
    lgraph = connectLayers(lgraph,"res2b_relu","res3a_branch2a");
    lgraph = connectLayers(lgraph,"res2b_relu","resize-reference-input_1/ref");
    lgraph = connectLayers(lgraph,"res2b_relu","depthcat_2/in1");
    lgraph = connectLayers(lgraph,"bn3a_branch1","res3a/in2");
    lgraph = connectLayers(lgraph,"bn3a_branch2b","res3a/in1");
    lgraph = connectLayers(lgraph,"res3a_relu","res3b_branch2a");
    lgraph = connectLayers(lgraph,"res3a_relu","res3b/in2");
    lgraph = connectLayers(lgraph,"bn3b_branch2b","res3b/in1");
    lgraph = connectLayers(lgraph,"res3b_relu","res4a_branch1");
    lgraph = connectLayers(lgraph,"res3b_relu","res4a_branch2a");
    lgraph = connectLayers(lgraph,"res3b_relu","resize-reference-input/ref");
    lgraph = connectLayers(lgraph,"res3b_relu","depthcat_1/in1");
    lgraph = connectLayers(lgraph,"bn4a_branch1","res4a/in2");
    lgraph = connectLayers(lgraph,"bn4a_branch2b","res4a/in1");
    lgraph = connectLayers(lgraph,"res4a_relu","res4b_branch2a");
    lgraph = connectLayers(lgraph,"res4a_relu","res4b/in2");
    lgraph = connectLayers(lgraph,"bn4b_branch2b","res4b/in1");
    lgraph = connectLayers(lgraph,"res4b_relu","res5a_branch1");
    lgraph = connectLayers(lgraph,"res4b_relu","res5a_branch2a");
    lgraph = connectLayers(lgraph,"res4b_relu","resize-reference-input_3/ref");
    lgraph = connectLayers(lgraph,"res4b_relu","depthcat/in1");
    lgraph = connectLayers(lgraph,"bn5a_branch1","res5a/in2");
    lgraph = connectLayers(lgraph,"bn5a_branch2b","res5a/in1");
    lgraph = connectLayers(lgraph,"res5a_relu","res5b_branch2a");
    lgraph = connectLayers(lgraph,"res5a_relu","res5b/in2");
    lgraph = connectLayers(lgraph,"bn5b_branch2b","res5b/in1");
    lgraph = connectLayers(lgraph,"relu","resize-reference-input_3/in");
    lgraph = connectLayers(lgraph,"resize-reference-input_3","depthcat/in2");
    lgraph = connectLayers(lgraph,"relu_1","resize-reference-input/in");
    lgraph = connectLayers(lgraph,"resize-reference-input","depthcat_1/in2");
    lgraph = connectLayers(lgraph,"relu_2","resize-reference-input_1/in");
    lgraph = connectLayers(lgraph,"resize-reference-input_1","depthcat_2/in2");
    lgraph = connectLayers(lgraph,"relu_3","resize-reference-input_2/in");
    lgraph = connectLayers(lgraph,"resize-reference-input_2","depthcat_3/in2");

    Net = lgraph;
    if ~isempty(n)
        save(n,'Net')
    end
end
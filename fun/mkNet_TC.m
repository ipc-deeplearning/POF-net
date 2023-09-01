function Net = mkNet_TC(input_size,n)
%MKNET_TC - 生成TC网络结构
%   此函数返回网络结构Net，它是输入大小为input_size
%
%   Net = MKNET_TC(input_size) 生成TC网络结构
%   Net = MKNET_TC(input_size,n) 生成TC网络结构并保存
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
        n char = [];
    end

    lgraph = layerGraph();

    x = input_size(1);
    y = input_size(2);
    L = input_size(3);

    tempLayers = imageInputLayer([x y L],"Name","data","Normalization","none");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(X)dlarray(reshape(X,height(X),[],1,size(X,4)),'SSCB'),"Name","concatWC1","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans1_Q","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat1_1","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans1_K","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat1_2","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans1_V","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat1_3","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(Q,K,V)attention(Q,K,V,1),"Name","attention1","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        functionLayer(@(X,Y)dlarray(permute(reshape(X,width(Y),[],size(X,2),size(X,3)),[4,1,2,3]),'SSCB'),"Name","rebuild2D1","Acceleratable",true,"Formattable",true)
        convolution2dLayer([1 7],56,"Name","conv1","BiasLearnRateFactor",0,"Padding","same","Stride",[1 2])
        batchNormalizationLayer("Name","bn_conv1")
        tanhLayer("Name","conv1_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],56,"Name","res2a_branch2a","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2a_branch2a")
        tanhLayer("Name","res2a_branch2a_relu")
        convolution2dLayer([3 3],56,"Name","res2a_branch2b","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2a_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res2a")
        tanhLayer("Name","res2a_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([3 3],56,"Name","res2b_branch2a","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2b_branch2a")
        tanhLayer("Name","res2b_branch2a_relu")
        convolution2dLayer([3 3],56,"Name","res2b_branch2b","BiasLearnRateFactor",0,"Padding",[1 1 1 1])
        batchNormalizationLayer("Name","bn2b_branch2b")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        additionLayer(2,"Name","res2b")
        tanhLayer("Name","res2b_relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([1 1],128,"Name","res3a_branch1","BiasLearnRateFactor",0,"Stride",[1 2])
        batchNormalizationLayer("Name","bn3a_branch1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(X)dlarray(reshape(X,height(X),[],1,size(X,4)),'SSCB'),"Name","concatWC2","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans2_Q","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat2_1","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans2_K","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat2_2","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans2_V","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat2_3","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(Q,K,V)attention(Q,K,V,1),"Name","attention2","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        functionLayer(@(X,Y)dlarray(permute(reshape(X,width(Y),[],size(X,2),size(X,3)),[4,1,2,3]),'SSCB'),"Name","rebuild2D2","Acceleratable",true,"Formattable",true)
        convolution2dLayer([1 3],128,"Name","res3a_branch2a","BiasLearnRateFactor",0,"Padding","same","Stride",[1 2])
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
        convolution2dLayer([1 1],256,"Name","res4a_branch1","BiasLearnRateFactor",0,"Stride",[1 2])
        batchNormalizationLayer("Name","bn4a_branch1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(X)dlarray(reshape(X,height(X),[],1,size(X,4)),'SSCB'),"Name","concatWC3","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans3_Q","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat3_1","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans3_K","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat3_2","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans3_V","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat3_3","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(Q,K,V)attention(Q,K,V,1),"Name","attention3","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        functionLayer(@(X,Y)dlarray(permute(reshape(X,width(Y),[],size(X,2),size(X,3)),[4,1,2,3]),'SSCB'),"Name","rebuild2D3","Acceleratable",true,"Formattable",true)
        convolution2dLayer([1 3],256,"Name","res4a_branch2a","BiasLearnRateFactor",0,"Padding","same","Stride",[1 2])
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
        convolution2dLayer([1 1],512,"Name","res5a_branch1","BiasLearnRateFactor",0,"Stride",[1 2])
        batchNormalizationLayer("Name","bn5a_branch1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(X)dlarray(reshape(X,height(X),[],1,size(X,4)),'SSCB'),"Name","concatWC4","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans4_Q","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat4_1","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans4_K","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat4_2","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        convolution2dLayer([x 1],x,"Name","trans4_V","Padding","same","Stride",[x 1])
        functionLayer(@(X)dlarray(squeeze(X),'CTB'),"Name","flat4_3","Acceleratable",true,"Formattable",true)];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = functionLayer(@(Q,K,V)attention(Q,K,V,1),"Name","attention4","Acceleratable",true,"Formattable",true);
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        functionLayer(@(X,Y)dlarray(permute(reshape(X,width(Y),[],size(X,2),size(X,3)),[4,1,2,3]),'SSCB'),"Name","rebuild2D4","Acceleratable",true,"Formattable",true)
        convolution2dLayer([1 3],512,"Name","res5a_branch2a","BiasLearnRateFactor",0,"Padding","same","Stride",[1 2])
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
        transposedConv2dLayer([3 3],256,"Name","transposed-conv","Cropping","same","Stride",[1 2])
        batchNormalizationLayer("Name","batchnorm")
        tanhLayer("Name","relu")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat")
        transposedConv2dLayer([3 3],128,"Name","transposed-conv_1","Cropping","same","Stride",[1 2])
        batchNormalizationLayer("Name","batchnorm_1")
        tanhLayer("Name","relu_1")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input_1","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat_1")
        transposedConv2dLayer([3 3],y,"Name","transposed-conv_2","Cropping","same","Stride",[1 2])
        batchNormalizationLayer("Name","batchnorm_2")
        tanhLayer("Name","relu_2")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input_2","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat_2")
        transposedConv2dLayer([3 3],16,"Name","transposed-conv_3","Cropping","same","Stride",[1 2])
        batchNormalizationLayer("Name","batchnorm_3")
        tanhLayer("Name","relu_3")];
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = resize2dLayer("Name","resize-reference-input_3","EnableReferenceInput",true,"GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round");
    lgraph = addLayers(lgraph,tempLayers);
    
    tempLayers = [
        depthConcatenationLayer(2,"Name","depthcat_3")
        transposedConv2dLayer([1 1],1,"Name","transposed-conv_4","Cropping","same")
        batchNormalizationLayer("Name","batchnorm_4")
        sigmoidLayer("Name","sigmoid")
        regressionLayer("Name","regressionoutput")];
    lgraph = addLayers(lgraph,tempLayers);
    
    % 清理辅助变量
    clear tempLayers;
    
    lgraph = connectLayers(lgraph,"data","concatWC1");
    lgraph = connectLayers(lgraph,"data","rebuild2D1/in2");
    lgraph = connectLayers(lgraph,"data","resize-reference-input_3/ref");
    lgraph = connectLayers(lgraph,"data","depthcat_3/in1");
    lgraph = connectLayers(lgraph,"concatWC1","trans1_Q");
    lgraph = connectLayers(lgraph,"concatWC1","trans1_K");
    lgraph = connectLayers(lgraph,"concatWC1","trans1_V");
    lgraph = connectLayers(lgraph,"flat1_1","attention1/in1");
    lgraph = connectLayers(lgraph,"flat1_2","attention1/in2");
    lgraph = connectLayers(lgraph,"flat1_3","attention1/in3");
    lgraph = connectLayers(lgraph,"attention1","rebuild2D1/in1");
    lgraph = connectLayers(lgraph,"conv1_relu","res2a_branch2a");
    lgraph = connectLayers(lgraph,"conv1_relu","res2a/in2");
    lgraph = connectLayers(lgraph,"bn2a_branch2b","res2a/in1");
    lgraph = connectLayers(lgraph,"res2a_relu","res2b_branch2a");
    lgraph = connectLayers(lgraph,"res2a_relu","res2b/in2");
    lgraph = connectLayers(lgraph,"bn2b_branch2b","res2b/in1");
    lgraph = connectLayers(lgraph,"res2b_relu","res3a_branch1");
    lgraph = connectLayers(lgraph,"res2b_relu","concatWC2");
    lgraph = connectLayers(lgraph,"res2b_relu","rebuild2D2/in2");
    lgraph = connectLayers(lgraph,"res2b_relu","resize-reference-input_2/ref");
    lgraph = connectLayers(lgraph,"res2b_relu","depthcat_2/in1");
    lgraph = connectLayers(lgraph,"bn3a_branch1","res3a/in2");
    lgraph = connectLayers(lgraph,"concatWC2","trans2_Q");
    lgraph = connectLayers(lgraph,"concatWC2","trans2_K");
    lgraph = connectLayers(lgraph,"concatWC2","trans2_V");
    lgraph = connectLayers(lgraph,"flat2_1","attention2/in1");
    lgraph = connectLayers(lgraph,"flat2_2","attention2/in2");
    lgraph = connectLayers(lgraph,"flat2_3","attention2/in3");
    lgraph = connectLayers(lgraph,"attention2","rebuild2D2/in1");
    lgraph = connectLayers(lgraph,"bn3a_branch2b","res3a/in1");
    lgraph = connectLayers(lgraph,"res3a_relu","res3b_branch2a");
    lgraph = connectLayers(lgraph,"res3a_relu","res3b/in2");
    lgraph = connectLayers(lgraph,"bn3b_branch2b","res3b/in1");
    lgraph = connectLayers(lgraph,"res3b_relu","res4a_branch1");
    lgraph = connectLayers(lgraph,"res3b_relu","concatWC3");
    lgraph = connectLayers(lgraph,"res3b_relu","rebuild2D3/in2");
    lgraph = connectLayers(lgraph,"res3b_relu","resize-reference-input_1/ref");
    lgraph = connectLayers(lgraph,"res3b_relu","depthcat_1/in1");
    lgraph = connectLayers(lgraph,"bn4a_branch1","res4a/in2");
    lgraph = connectLayers(lgraph,"concatWC3","trans3_Q");
    lgraph = connectLayers(lgraph,"concatWC3","trans3_K");
    lgraph = connectLayers(lgraph,"concatWC3","trans3_V");
    lgraph = connectLayers(lgraph,"flat3_1","attention3/in1");
    lgraph = connectLayers(lgraph,"flat3_2","attention3/in2");
    lgraph = connectLayers(lgraph,"flat3_3","attention3/in3");
    lgraph = connectLayers(lgraph,"attention3","rebuild2D3/in1");
    lgraph = connectLayers(lgraph,"bn4a_branch2b","res4a/in1");
    lgraph = connectLayers(lgraph,"res4a_relu","res4b_branch2a");
    lgraph = connectLayers(lgraph,"res4a_relu","res4b/in2");
    lgraph = connectLayers(lgraph,"bn4b_branch2b","res4b/in1");
    lgraph = connectLayers(lgraph,"res4b_relu","res5a_branch1");
    lgraph = connectLayers(lgraph,"res4b_relu","concatWC4");
    lgraph = connectLayers(lgraph,"res4b_relu","rebuild2D4/in2");
    lgraph = connectLayers(lgraph,"res4b_relu","resize-reference-input/ref");
    lgraph = connectLayers(lgraph,"res4b_relu","depthcat/in1");
    lgraph = connectLayers(lgraph,"bn5a_branch1","res5a/in2");
    lgraph = connectLayers(lgraph,"concatWC4","trans4_Q");
    lgraph = connectLayers(lgraph,"concatWC4","trans4_K");
    lgraph = connectLayers(lgraph,"concatWC4","trans4_V");
    lgraph = connectLayers(lgraph,"flat4_1","attention4/in1");
    lgraph = connectLayers(lgraph,"flat4_2","attention4/in2");
    lgraph = connectLayers(lgraph,"flat4_3","attention4/in3");
    lgraph = connectLayers(lgraph,"attention4","rebuild2D4/in1");
    lgraph = connectLayers(lgraph,"bn5a_branch2b","res5a/in1");
    lgraph = connectLayers(lgraph,"res5a_relu","res5b_branch2a");
    lgraph = connectLayers(lgraph,"res5a_relu","res5b/in2");
    lgraph = connectLayers(lgraph,"bn5b_branch2b","res5b/in1");
    lgraph = connectLayers(lgraph,"relu","resize-reference-input/in");
    lgraph = connectLayers(lgraph,"resize-reference-input","depthcat/in2");
    lgraph = connectLayers(lgraph,"relu_1","resize-reference-input_1/in");
    lgraph = connectLayers(lgraph,"resize-reference-input_1","depthcat_1/in2");
    lgraph = connectLayers(lgraph,"relu_2","resize-reference-input_2/in");
    lgraph = connectLayers(lgraph,"resize-reference-input_2","depthcat_2/in2");
    lgraph = connectLayers(lgraph,"relu_3","resize-reference-input_3/in");
    lgraph = connectLayers(lgraph,"resize-reference-input_3","depthcat_3/in2");

    Net = lgraph;
    if ~isempty(n)
        save(n,'Net')
    end
end
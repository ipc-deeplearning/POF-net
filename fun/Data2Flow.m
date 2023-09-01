function Flow = Data2Flow(Data)
    opticFlow = opticalFlowLK('NoiseThreshold',0.0005);
    v1 = VideoWriter('./tempVideo.avi');
    v2 = VideoWriter('./tempVideo-.avi');
    open(v1)
    open(v2)
    for i = 1:size(Data,3)
        writeVideo(v1,Data(:,:,i))
        writeVideo(v2,Data(:,:,end+1-i))
    end
    close(v1)
    close(v2)
    vidReader1 = VideoReader('./tempVideo.avi');
    vidReader2 = VideoReader('./tempVideo-.avi');
    k = 0;
    while hasFrame(vidReader1)
        k = k + 1;
        frame = readFrame(vidReader1);
        frame = rgb2gray(frame);
        flow = estimateFlow(opticFlow,frame);
        Flow.Vx{k,1} = flow.Vx./abs(flow.Vx.^2+flow.Vy.^2);
        Flow.Vx{k,1}(isnan(Flow.Vx{k,1})) = 0;
        Flow.Vy{k,1} = flow.Vy./abs(flow.Vx.^2+flow.Vy.^2);
        Flow.Vy{k,1}(isnan(Flow.Vy{k,1})) = 0;
    end
    k = 0;
    while hasFrame(vidReader2)
        k = k + 1;
        frame = readFrame(vidReader2);
        frame = rgb2gray(frame);
        flow = estimateFlow(opticFlow,frame);
        Flow.Vx{k,2} = flow.Vx./abs(flow.Vx.^2+flow.Vy.^2);
        Flow.Vx{k,2}(isnan(Flow.Vx{k,2})) = 0;
        Flow.Vy{k,2} = flow.Vy./abs(flow.Vx.^2+flow.Vy.^2);
        Flow.Vy{k,2}(isnan(Flow.Vy{k,2})) = 0;
    end
    for j = 1:size(Data,3)
        img{j} = cat(3,im2double(Data(:,:,j)),...
            abs(Flow.Vx{j,1}-Flow.Vx{k-j+1,2})/2,...
            abs(Flow.Vy{j,1}-Flow.Vy{k-j+1,2})/2);     
    end
    Flow = cat(4,img{:});
end
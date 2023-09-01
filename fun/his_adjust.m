function his_adjust(path,path0)
    imds = imageDatastore([path,'/polHolo/img'],...
        "FileExtensions",".png",...
        "IncludeSubfolders",true);
    imds0 = imageDatastore([path0,'/polHolo/img'],...
        "FileExtensions",".png",...
        "IncludeSubfolders",true);
    imds = readall(imds);
    imds = cat(3,imds{:});
    imds0 = readall(imds0);
    imds0 = cat(3,imds0{:});
    a = imhist(imds0);
    [~,T] = histeq(imds,a);
    load([path,'/wphy.mat'])
    wphy.T = T;
    save([path,'/wphy.mat'],"wphy")
    I = imageDatastore([path,'/HoloAll'],...
        "FileExtensions",".png",...
        "IncludeSubfolders",true);
    I = readall(I);
    I = cat(3,I{:});
    I = T(I+1);
    for i = 1:size(I,3)
        imwrite(I(:,:,i),[path,'/HoloAll/',num2str(i,'%03d'),'.png'])
    end
    for i = 1:wphy.par.N
        I = imageDatastore([path,'/HoloSingle/',num2str(i)],...
        "FileExtensions",".png",...
        "IncludeSubfolders",true);
        I = readall(I);
        I = cat(3,I{:});
        I = T(I+1);
        for j = 1:size(I,3)
            imwrite(I(:,:,j),[path,'/HoloSingle/',num2str(i),'/',...
                num2str(j,'%03d'),'.png'])
        end
    end
end
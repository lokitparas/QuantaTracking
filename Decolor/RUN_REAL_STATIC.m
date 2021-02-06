clear all
close all

addpath('internal');
addpath(genpath('gco-v3.0'));
 

dataName = '0108-newton-filament-2'; 

inputdata='/Users/lokitparas/Desktop/IndependentStudy/QuantaTracking/Datasets & Results/0108-newton-filament-2/output_images/lokit/patchWiener/patchWienerMerge'
mkdir(strcat('resultImages/',dataName)); 
ImData = zeros(256,512,33);
count = 1;

for i = 1:34
     img = imread(strcat(inputdata,int2str(i-1),'.png'));
     img = histeq(img);

     % controls gaussian blur 
     img = imgaussfilt(img,1.25);
     ImData(:,:,count) = img;
     count =count+ 1;
 end


%% run DECOLOR
 [LowRank,Mask,tau,info] = ObjDetection_DECOLOR(ImData);
 save(['result/' dataName '_DECOLOR.mat'],'dataName','Mask','LowRank','tau','info');    

%% displaying
load(['result/' dataName '_DECOLOR.mat'],'dataName','Mask','LowRank','tau');
moviename = ['result/' dataName,'_DECOLOR.avi']; fps = 12;
mov = VideoWriter(moviename,'MPEG-4');
mov.Quality = 100;
mov.FrameRate = fps;
open(mov)
for i = 1:size(ImData,3)
    figure(1); clf;
    subplot(2,2,1);
    original = rescale(ImData(:,:,i));
    imshow(original), axis off, colormap gray; axis off;
    title('Original image','fontsize',12);
    subplot(2,2,2);
    imshow(LowRank(:,:,i)), axis off,colormap gray; axis off;
    title('Low Rank','fontsize',12);
    subplot(2,2,3);
    imshow(rescale(ImData(:,:,i))), axis off,colormap gray; axis off;
    hold on; contour(Mask(:,:,i),[0 0],'y','linewidth',5);
    title('Segmentation','fontsize',12);
    subplot(2,2,4);
    
    finalMask = rescale(ImData(:,:,i).*Mask(:,:,i));
    imshow(finalMask), axis off, colormap gray; axis off;
    title('Foreground','fontsize',12);
    imwrite(finalMask,strcat('resultImages/',dataName,'/img_',int2str(i),'.png'));
    writeVideo(mov,finalMask);
end
close(mov);

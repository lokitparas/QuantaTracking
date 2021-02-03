dataName = 'Bright'; 
moviename = ['result/' dataName,'_vidnew.avi'];
mov = VideoWriter(moviename);
mov.Quality = 100;
mov.FrameRate = 10;
open(mov)

for i = 70:160
     img = imread(strcat('/Users/lokitparas/Downloads/Data/Bright_400/img_',int2str(i),'.png'));
 %     img = imread(strcat('../GMM/Low_fast/img_',int2str(i),'.png'));
     img = histeq(img);
     writeVideo(mov,img);
end
close(mov)

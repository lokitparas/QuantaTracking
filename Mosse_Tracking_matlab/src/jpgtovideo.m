%https://blog.csdn.net/hjl240/article/details/52402543

framesPath = 'results_tempSurfer/';%ͼ����������·����ͬʱҪ��֤ͼ���С��ͬ
videoName = 'testtemp.avi';%��ʾ��Ҫ��������Ƶ�ļ�������
fps = 30; %֡��
startFrame = 1; %����һ֡��ʼ
endFrame = 376; %��һ֡����
 
if(exist('videoName','file'))
    delete videoName.avi
end
 
%������Ƶ�Ĳ����趨
aviobj=VideoWriter(videoName);  %����һ��avi��Ƶ�ļ����󣬿�ʼʱ��Ϊ��
aviobj.FrameRate=fps;
 
open(aviobj);%Open file for writing video data
%����ͼƬ
for i=startFrame:endFrame
    fileName=sprintf('%04d',i);    %�����ļ������� �������ļ�����0001.jpg 0002.jpg ....
    frames=imread([framesPath,fileName,'.jpg']);
    writeVideo(aviobj,frames);
end
close(aviobj);% �رմ�����Ƶ

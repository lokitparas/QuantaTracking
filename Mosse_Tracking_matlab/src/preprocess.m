function img = preprocess(img)
[r,c] = size(img);   %��ȡimg �ĸ߿�
win = window2(r,c,@hann);   %��ʼ��hann��
eps = 1e-5;
img = log(double(img)+1);
img = (img-mean(img(:)))/(std(img(:))+eps);   %��ͼ�����ݽ��б�׼������
img = img.*win;    %��ͼƬ����hann��
end

img = double(imread(strcat('/Users/lokitparas/Downloads/Data/Timeoverlap/Ultradark_100/img_1.png')));
img = img*100/255;
figure; hist(img)
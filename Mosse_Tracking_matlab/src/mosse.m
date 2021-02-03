% get images from source directory
datadir = '../data/';
dataset = 'smart_avg_overlap_800_600overlap_extra';
path = [datadir dataset];
img_path = [path '/'];
image_info = dir(fullfile(img_path,'*.png'));
seq_len = length(image_info);
img_files =string.empty;
% for item = 1:seq_len
%     img_files(item) = strcat(img_path, image_info(item).name);
% end
img_files = fullfile(img_path,{image_info.name});

img_files = natsortfiles(img_files);
% select target from first frame
% img_files{10}
im = imread(img_files{1}); 
imshow(im)
%[X,map]=imread('forest.png')  
% f = figure('Name', 'Select object to track'); imshow(im);   
% 
% rect = getrect;
% 
% center = [rect(2)+rect(4)/2 rect(1)+rect(3)/2];
[rect,center] = bbox(im)
center = [rect(2)+rect(4)/2 rect(1)+rect(3)/2];

% plot gaussian
sigma = 100;
gsize = size(im); 
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));
%ndgrid用法：https://blog.csdn.net/u012183487/article/details/76149279
g = gaussC(R,C, sigma, center);  %调用高斯函数
g = mat2gray(g);%把一个double类的任意数组转换成值范围在[0,1]的归一化double类数组

% randomly warp original image to create training set
if (size(im,3) == 3) %size(A,n)，size将返回矩阵的行数或列数
    img = rgb2gray(im);  %将RGB图像或彩色图转换为灰度图像
end
%imcrop表示按第一帧选择的矩形大小裁剪图片
img = imcrop(im, rect); %按选定的矩形框裁剪第一帧灰度图大小
%imcrop ： https://blog.csdn.net/llxue0925/article/details/80431508
g = imcrop(g, rect); %
G = fft2(g);   %二维快速傅里叶变换，将响应输出g变成G
height = size(g,1);   %height=179
width = size(g,2);    %width=130
%f表示输入图像
fi = preprocess(imresize(img, [height width])); 
%重新设置裁剪后的图片尺寸，再调用preprocess函数对图像数据进行标准化处理
Ai = (G.*conj(fft2(fi))); %conj函数用于计算"复数"x的共轭值。即F*--》F的共轭
Bi = (fft2(fi).*conj(fft2(fi)));
% %按照求和公式计算第一个H
N = 128;
for i = 1:N
    fi = preprocess(rand_warp(img));
    Ai = Ai + (G.*conj(fft2(fi)));
    Bi = Bi + (fft2(fi).*conj(fft2(fi)));
end

% % MOSSE online training regimen
eta = 0.00125;   %官方推荐的eta值0.125
fig = figure('Name', 'MOSSE');
mkdir(['results_' dataset]);
for i = 1:size(img_files,2)  %遍历所有图片
    %size(img_files, 1) 表示图片总数量
    img = imread(img_files{i});   %读取第i张图片
    im = img;
    if (size(img,3) == 3)  %若通道为3
        img = rgb2gray(img);  %转成灰度图
    end
    if (i == 1)      %当为第一张图时
        Ai = eta.*Ai;
        Bi = eta.*Bi;
    else
        Hi = Ai./Bi;   %不是第一张图的时候，求解滤波H*
        fi = imcrop(img, rect);   %再按指定矩形大小进行裁剪2-376的对应图片
        fi = preprocess(imresize(fi, [height width]));  %预处理得到输出
        gi = uint8(255*mat2gray(ifft2(Hi.*fft2(fi))));  %得到响应值输出 转换成值范围在[0,1]的归一化double类数组 
        maxval = max(gi(:));  %得到最大响应值
        [P, Q] = find(gi == maxval);  %找到最大响应值所对应的gi
        dx = mean(P)-height/2;
        dy = mean(Q)-width/2;

        
        newCenX = mean(P);
        newCenY = mean(Q);
        
        side_lobe = zeros(1,(height*width)-121);
        count = 1;
        for x = 1:size(gi,1)
            for y = 1:size(gi,2)
                if abs(x - newCenX) > 5 && abs(y - newCenY) > 5
                    side_lobe(count) = gi(x,y);
                    count = count +1;
                end
            end
        end
        
        mu1 = mean(side_lobe);
        s1 = std(side_lobe);
        
        PSR = double(maxval - mu1)/s1
        
        if PSR < 2 | abs(dx) > 3 | abs(dy) > 3
            disp('New bbox');
            try
                [rect,cent] = bbox(img);
            catch
                rect = rect;
            end
        else
%             disp('Old bbox');
            rect = [rect(1)+dy rect(2)+dx width height];  %更新中心点坐标
        end
        
%         if abs(dx) > 3 | abs(dy) > 3
%             disp('New bbox');
%             PSR
%             [rect,cent] = bbox(img);
%         else
% %             disp('Old bbox');
%             rect = [rect(1)+dy rect(2)+dx width height];  %更新中心点坐标
%         end
        
        fi = imcrop(img, rect);     %按新更新的rect目标点进行裁剪图片 
        fi = preprocess(imresize(fi, [height width]));
        %最后更新Ai和Bi
        Ai = eta.*(G.*conj(fft2(fi))) + (1-eta).*Ai;
        Bi = eta.*(fft2(fi).*conj(fft2(fi))) + (1-eta).*Bi;
    end
    
    % visualization
    text_str = ['Frame: ' num2str(i)];   %每一张图片代表一帧
    box_color = 'green';
    position=[1 1];
    result = insertText(im, position,text_str,'FontSize',15,'BoxColor',...
                     box_color,'BoxOpacity',0.4,'TextColor','white');
    result = insertShape(result, 'Rectangle', rect, 'LineWidth', 3); %绘制矩形 宽为3
    imwrite(result, ['results_' dataset num2str(i, '/%04i.jpg')]);
    %imwrite(result, ['results_temp' dataset num2str(i, '/%04i.jpg')]);
    imshow(result);
end

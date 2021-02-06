count=1
for i = 1:14
    x = load(strcat('part_',string(i),'.mat'))
    s = size(x.OUTPUT)
    for idx = 1:s(3)
        disp(idx)
        imwrite(x.OUTPUT(:,:,idx), strcat('seq/img_',string(count),'.png'))
        count=count+1
    end
end

    
function val = gaussC(x, y, sigma, center)
    xc = center(1);  %���ĵ������
    yc = center(2);  %���ĵ�������
    exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma);
    val       = (exp(-exponent)); 
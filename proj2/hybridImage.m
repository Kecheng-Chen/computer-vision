function img=hybridImage(im1, im2, cutoff_low, cutoff_high)
    sigma = cutoff_low;
    [a,b]=size(im1);
    [x,y]=meshgrid(-floor(b/2):b-floor(b/2)-1,-floor(a/2):a-floor(a/2)-1);
    Exp_comp = -(x.^2+y.^2);
    lowKernel= exp(Exp_comp/(2*(sigma^2)));
    sigma2 = cutoff_high;
    Exp_comp2 = -(x.^2+y.^2);
    lowKernel2= exp(Exp_comp2/(2*(sigma2^2)));
    hiKernel=1-lowKernel2;
    im1=fftshift(fft2(double(im1)));
	im2=fftshift(fft2(double(im2)));
    J=im1.*lowKernel;
    J1=ifftshift(J);
    img1=ifft2(J1);
    K=im2.*hiKernel;
    K1=ifftshift(K);
    img2=ifft2(K1);
%     figure;
%     imagesc(log(abs(fftshift(fft2(img1)))));
%     figure;
%     imagesc(log(abs(fftshift(fft2(img2)))));
%     figure;
%     imagesc(log(abs(fftshift(fft2(img1+img2)))));
    img=img1+img2;
end
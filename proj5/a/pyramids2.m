function imarray=pyramids2(im,N,method)
    im=im2single(im);
    [a,b,c]=size(im);
    imarray=zeros(a,b,N,c);
    sigma = 15;
    [x,y]=meshgrid(-floor(b/2):b-floor(b/2)-1,-floor(a/2):a-floor(a/2)-1);
    Exp_comp = -(x.^2+y.^2);
    lowKernel= exp(Exp_comp/(2*(sigma^2)));
%     subplot(2,round(N/2),1)
%     imshow(im);
    for j=1:c
    for i=1:N
        im1=fftshift(fft2(double(im(:,:,j))));
        J=im1.*lowKernel;
        J1=ifftshift(J);
        if method=='G'
            imarray(:,:,i,j)=ifft2(J1);
        else
            imarray(:,:,i,j)=im(:,:,j)-ifft2(J1);
        end
        im(:,:,j)=ifft2(J1);
    end
    end
end
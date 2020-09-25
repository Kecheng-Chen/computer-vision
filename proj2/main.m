%% part1.1: Finite Difference Operator
clear;clc;
imname = 'cameraman.png';
fullim = imread(imname);
[a,b]=size(fullim);
fullim = im2double(fullim);
I = rgb2gray(fullim);
imshow(I);

%%
I_x=conv2(I,[1,-1],'same');
%imshow(I_x)
imwrite(I_x,'1.jpg');
I_y=conv2(I,[1,-1]','same');
%imshow(I_y)
imwrite(I_y,'2.jpg');
I_xy=(I_x.^2+I_y.^2).^(0.5);
subplot(1,2,1)
imshow(I_xy)
I_xy_new=I_xy>0.2;
subplot(1,2,2)
imshow(I_xy_new)
saveas(gcf,'3.jpg');

%% part1.2: Derivative of Gaussian (DoG) Filter
clear;clc;
imname = 'cameraman.png';
fullim = imread(imname);
[a,b]=size(fullim);
fullim = im2double(fullim);
I = rgb2gray(fullim);
imshow(I);

sigma = 2;
sz = 6;
[x,y]=meshgrid(-sz:sz,-sz:sz);
Exp_comp = -(x.^2+y.^2)/(2*(sigma^2));
Kernel= exp(Exp_comp)/(2*pi*(sigma^2));

%%
%mesh(Kernel)
%saveas(gcf,'4.jpg');
I_ga=conv2(I,Kernel,'same');
%imshow(I_ga)
I_x_ga=conv2(I_ga,[1,-1],'same');
%imshow(I_x)
%imwrite(I_x_ga,'6.jpg');
I_y_ga=conv2(I_ga,[1,-1]','same');
%imshow(I_y)
%imwrite(I_y_ga,'7.jpg');
I_xy_ga=(I_x_ga.^2+I_y_ga.^2).^(0.5);
imshow(I_xy_ga)
%saveas(gcf,'8.jpg');

%% convolve the gaussian with D_x and D_y
I_x_ga=conv2(I,conv2([1,-1],Kernel,'full'),'same');
I_y_ga=conv2(I,conv2([1,-1]',Kernel,'full'),'same');
I_xy_ga=(I_x_ga.^2+I_y_ga.^2).^(0.5);
imshow(I_xy_ga)
%saveas(gcf,'9.jpg');

%% part1.3: Image Straightening
clc;clear;
sigma = 2;
sz = 6;
[x,y]=meshgrid(-sz:sz,-sz:sz);
Exp_comp = -(x.^2+y.^2)/(2*(sigma^2));
Kernel= exp(Exp_comp)/(2*pi*(sigma^2));

I = imread('facade.jpg');
I = im2double(I);
I = rgb2gray(I);
[a,b]=size(I);
per=0.2;
max=0;
maxi=0;
for i=-10:10
    J=imrotate(I,i,'bilinear','crop');
    left=round(b*per);
    right=b-left;
    top=round(per*a);
    bottom=a-top;
    J=J(top:bottom,left:right);
    J_x_ga=conv2(J,conv2([1,-1],Kernel,'full'),'same');
    J_y_ga=conv2(J,conv2([1,-1]',Kernel,'full'),'same');
    theta=atan(J_y_ga./J_x_ga)/pi*180;
    coun=sum(theta(:)<5 & theta(:)>-5)+sum(theta(:)>-95 & theta(:)<-85)+sum(theta(:)>85 & theta(:)<95);
    if coun>max
        max=coun;
        maxi=i;
    end
end
subplot(1,2,1)
imshow(imread('facade.jpg'));
subplot(1,2,2)
imshow(imrotate(imread('facade.jpg'),maxi,'bilinear','crop'));

%% part2.1: Image "Sharpening"
clear;clc;
imname = 'taj.jpg';
fullim = imread(imname);
[a,b]=size(fullim(:,:,1));
fullim = im2double(fullim);

%%
sigma = 2;
sz = 6;
[x,y]=meshgrid(-sz:sz,-sz:sz);
Exp_comp = -(x.^2+y.^2)/(2*(sigma^2));
Kernel= exp(Exp_comp)/(2*pi*(sigma^2));
impulse=zeros(13,13);
impulse(7,7)=1;

%%
alpha=2;
newim=zeros(a,b,3);
for i=1:3
    J=fullim(:,:,i);
    newim(:,:,i)=conv2(J,((1+alpha)*impulse-alpha*Kernel),'same');
end
imshow(newim)
% imwrite(newim,'dalpha10.jpg');

%% blur the sharp image
% newim=zeros(a,b,3);
% for i=1:3
%     J=fullim(:,:,i);
%     newim(:,:,i)=conv2(J,Kernel,'same');
% end
% imshow(newim)
% imwrite(newim,'stb.jpg');

%% part2.2: Hybrid Images
% read images and convert to single format
im1 = im2single(imread('DerekPicture.jpg'));
im2 = im2single(imread('nutmeg.jpg'));
im1 = rgb2gray(im1); % convert to grayscale
im2 = rgb2gray(im2);

% use this if you want to align the two images (e.g., by the eyes) and crop
% them to be of same size
[im2, im1] = align_images(im2, im1);

%% hybrid
arb=40;
cutoff_low = arb;
cutoff_high = arb;
im12 = hybridImage(im1, im2, cutoff_low, cutoff_high);
imshow(im12);

%% crop
figure(1), hold off, imagesc(im12), axis image, colormap gray
disp('input crop points');
[x, y] = ginput(2);  x = round(x); y = round(y);
im12 = im12(min(y):max(y), min(x):max(x), :);
figure(1), hold off, imagesc(im12), axis image, colormap gray
% log magnitude of the Fourier transform of the images
% imagesc(log(abs(fftshift(fft2(im12)))))

%% part2.3: Gaussian and Laplacian Stacks
clear;clc;
N = 5;
% Gaussian Stack
% pyramids(imread('lincoln.jpg'), N, 'L');
% Laplacian Stack
pyramids(imread('lincoln.jpg'), N, 'G');

%% part 2.4: Multiresolution Blending
clear;clc;
im1 = rgb2gray(im2single(imread('apple.jpeg')));
im2 = rgb2gray(im2single(imread('orange.jpeg')));
[a,b]=size(im1);
% if use irregular mask, please uncomment the line below and comment the
% following two lines after this line.
% mask_A=mask;
mask_A = zeros(a,b);
mask_A(:,1:floor(b/2)) = 1;
C = (im1 .* mask_A) + (im2 .* (1 - mask_A));
imshow(C)

%% algorithm
N = 5; % number of pyramid levels (you may use more or fewer, as needed)
LA=pyramids2(im1, N,'L');
LB=pyramids2(im2, N,'L');
GR=pyramids2(mask_A, N,'G');
LS=GR.*LA+(1-GR).*LB;
GC=pyramids2(C, N,'G');
S=sum(LS,3)+GC(:,:,N);
figure;
imshow(S)

%% extra plot
for i=1:5
    subplot(1,5,i);
    hold on;
    imshow(imadjust(LS(:,:,i)));
end

%% irregular mask filter
% I = imread('6.jpg');
% imshow(I)
% % h = drawellipse('Center',[150 150],'SemiAxes',[20 20], ...
% %     'RotationAngle',0,'StripeColor','m');
% h=drawpolygon;
% mask = createMask(h);
% imshow(mask)
% drawrectangle

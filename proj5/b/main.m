%% load image
clear;clc;
img1=imread('e1.jpg');
img2=imread('e2.jpg');
%img3=imread('3.jpg');
filename = 'result3.xlsx';
A = xlsread(filename);
x1=A(2:end,1);
y1=A(2:end,2);
x2=A(2:end,3);
y2=A(2:end,4);
fixed=img2;
moving=img1;
movingPoints(:,1)=y1;
movingPoints(:,2)=x1;
fixedPoints(:,1)=y2;
fixedPoints(:,2)=x2;

%% blend image (if use RANSAC, please direct jump to the RANSAC section and don't run this part)
H = computeH(movingPoints,fixedPoints);
[imwarped,bb] = warpImage_new(double(moving),H);
new=uint8(imwarped);
new((-bb(3)+2):(size(img1,1)-bb(3)+1),(-bb(1)+2):(size(img1,2)-bb(1)+1),:)=...
    new((-bb(3)+2):(size(img1,1)-bb(3)+1),(-bb(1)+2):(size(img1,2)-bb(1)+1),:)+fixed;
imshow(uint8(new))

%% defination of masks and images
im4=zeros(size(imwarped));
im4((-bb(3)+2):(size(img1,1)-bb(3)+1),(-bb(1)+2):(size(img1,2)-bb(1)+1),:)=fixed;
mask_A = zeros(size(imwarped));
mask_A(:,1:600,:) = 1;
C = uint8(imwarped .* mask_A) + uint8(im4 .* (1 - mask_A));
imshow(C)

%% laplacian pyramid
N = 2;
imwarped=uint8(imwarped);
im4=uint8(im4);
LA=pyramids2(imwarped, N,'L');
LB=pyramids2(im4, N,'L');
GR=pyramids2(mask_A, N,'G');
GC=pyramids2(C, N,'G');
[a,b,c]=size(imwarped);
LS=zeros(a,b,N,c);
S=zeros(a,b,c);
for i=1:3
    LS(:,:,:,i)=GR(:,:,:,i).*LA(:,:,:,i)+(1-GR(:,:,:,i)).*LB(:,:,:,i);
    S(:,:,i)=sum(LS(:,:,:,i),3)+GC(:,:,N,i);
end
figure;
imshow(S)

%% save image
A = repmat(1, size(S,[1,2]));
A(C(:,:,1)==0) = 0;
imwrite(S, 'ee2.png', 'Alpha', A);

%% RANSAC
n = length(x1);
coun=0;
for i=1:10000
    x = randsample(n,4);
    H = computeH(movingPoints(x,:),fixedPoints(x,:));
    M=H*[movingPoints(:,1)';movingPoints(:,2)';ones(1,length(x1))];
    dist=(M(1,:)./M(3,:)-fixedPoints(:,1)').^2+(M(2,:)./M(3,:)-fixedPoints(:,2)').^2;
    idx=dist<=1;
    out=sum(idx(:));
    if out>coun
        coun=out;
        k=find(dist<=1);
    end
end

%%
movingPoints=movingPoints(k,:);
fixedPoints=fixedPoints(k,:);

%%
H = computeH(movingPoints,fixedPoints);
[imwarped,bb] = warpImage_new(double(moving),H);
im4=zeros(size(imwarped));
im4((-bb(3)+2):(size(img1,1)-bb(3)+1),(-bb(1)+2):(size(img1,2)-bb(1)+1),:)=fixed;
mask_A = zeros(size(imwarped));
mask_A(:,1:500,:) = 1;
C = uint8(imwarped .* mask_A) + uint8(im4 .* (1 - mask_A));
imshow(C)

%%
N = 2;
imwarped=uint8(imwarped);
im4=uint8(im4);
LA=pyramids2(imwarped, N,'L');
LB=pyramids2(im4, N,'L');
GR=pyramids2(mask_A, N,'G');
GC=pyramids2(C, N,'G');
[a,b,c]=size(imwarped);
LS=zeros(a,b,N,c);
S=zeros(a,b,c);
for i=1:3
    LS(:,:,:,i)=GR(:,:,:,i).*LA(:,:,:,i)+(1-GR(:,:,:,i)).*LB(:,:,:,i);
    S(:,:,i)=sum(LS(:,:,:,i),3)+GC(:,:,N,i);
end
figure;
imshow(S)

%%
A = repmat(1, size(S,[1,2]));
A(C(:,:,1)==0) = 0;
imwrite(S, 'ee4.png', 'Alpha', A);
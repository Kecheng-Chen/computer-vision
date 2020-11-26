%% load image
img1=imread('1.jpg');
img2=imread('2.jpg');
img3=imread('3.jpg');

%% control point selection
fixed=img2;
moving=img1;
cpselect('c1.jpg','c2.jpg');

%% normalized correlation matching
movingPointsAdjusted = cpcorr(movingPoints,fixedPoints,moving(:,:,1),fixed(:,:,1));
figure; imshow(moving)
hold on
plot(movingPoints(:,1),movingPoints(:,2),'xw') 
title('moving')
plot(movingPointsAdjusted(:,1),movingPointsAdjusted(:,2),'xy') 

%% Warp image
H = computeH(movingPointsAdjusted,fixedPoints);
imwarped = warpImage(double(moving),H);

%% save image with transparent background
A = repmat(1, size(imwarped,[1,2]));
A(isnan(imwarped(:,:,1))) = 0;
imwrite(uint8(imwarped), 's4.png', 'Alpha', A);

%% Image rectification: part 1
church=imread('church1.jpg');
imshow(church);
[x,y] = getpts;

%% Image rectification: part 2
H = computeH([x y],[1 1;1 100;100 100;100 1]);
imwarped = warpImage(double(church),H);
imshow(uint8(imwarped))

%% blend image
H = computeH(movingPointsAdjusted,fixedPoints);
[imwarped,bb] = warpImage_new(double(moving),H);
new=uint8(imwarped);
new((-bb(3)+2):(600-bb(3)+1),(-bb(1)+2):(900-bb(1)+1),:)=...
    new((-bb(3)+2):(600-bb(3)+1),(-bb(1)+2):(900-bb(1)+1),:)+fixed;
imshow(uint8(new))

%% defination of masks and images
im4=zeros(size(imwarped));
im4((-bb(3)+2):(600-bb(3)+1),(-bb(1)+2):(900-bb(1)+1),:)=fixed;
mask_A = zeros(size(imwarped));
mask_A(500:end,:,:) = 1;
C = uint8(imwarped .* mask_A) + uint8(im4 .* (1 - mask_A));
imshow(C)

%% laplacian pyramid
N = 5;
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
imwrite(S, 'c3.png', 'Alpha', A);
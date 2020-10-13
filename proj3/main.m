%% Defining Correspondences
clear;clc;
moving = imread('A.jpg');
fixed = imread('B.jpg');
% cpselect('A.jpg','B.jpg');
final=zeros(size(fixed,1),size(fixed,2));

%% Load keypoints
load('fixpoint.mat');
load('movingpoint.mat');
newpoints=(fixedPoints+movingPoints)./2;
x=newpoints(:,1);
y=newpoints(:,2);
DT = delaunay(x,y);
triplot(DT,x,y);

%%
% imshow(fixed);hold on;
% x1=fixedPoints(:,1);
% y1=fixedPoints(:,2);
% DT1 = delaunay(x1,y1);
% triplot(DT,x,y);
% imshow(moving);hold on;
% x2=movingPoints(:,1);
% y2=movingPoints(:,2);
% DT2 = delaunay(x2,y2);
% triplot(DT,x,y);

%% image A and B to middle image
[X,Y]=meshgrid(1:size(fixed,2),1:size(fixed,1));
X1=zeros(size(X));
Y1=zeros(size(Y));
X2=X1;
Y2=Y1;
for i=1:size(DT,1)
    tri2_pts=ones(3,3);
    tri1_pts=tri2_pts;
    tri3_pts=tri2_pts;
    N=newpoints(DT(i,:),:);
    tri1_pts(1:2,:)=(N)';
    BW = roipoly(fixed,N(:,1),N(:,2));
    tri2_pts(1:2,:)=(fixedPoints(DT(i,:),:))';
    tri3_pts(1:2,:)=(movingPoints(DT(i,:),:))';
    T=computeAffine(tri1_pts,tri2_pts);
    T2=computeAffine(tri1_pts,tri3_pts);
    X1=X1+(T(1,1)*X+T(1,2)*Y+T(1,3)).*BW;
    Y1=Y1+(T(2,1)*X+T(2,2)*Y+T(2,3)).*BW;
    X2=X2+(T2(1,1)*X+T2(1,2)*Y+T2(1,3)).*BW;
    Y2=Y2+(T2(2,1)*X+T2(2,2)*Y+T2(2,3)).*BW;
end
fixed_mid=zeros(size(fixed));
for i=1:3
    fixed_mid(:,:,i) = interp2(X,Y,(im2double(fixed(:,:,i))),X1,Y1);
end
figure;hold on;
imshow(fixed_mid);
hold off;
moving_mid=zeros(size(fixed));
for i=1:3
    moving_mid(:,:,i) = interp2(X,Y,(im2double(moving(:,:,i))),X2,Y2);
end
figure;hold on;
imshow(moving_mid);
hold off;

%% get the middle face
mid=0.5*fixed_mid+0.5*moving_mid;
imshow(mid);

%% Morph Sequence
h = figure;
for t=0:0.1:1
    morphed_im = morph(fixed, moving, fixedPoints, movingPoints, 0, t, t);
    imshow(morphed_im);
    drawnow
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    if t == 0 
        imwrite(imind,cm,'1.gif', 'gif','Loopcount',inf); 
    else 
        imwrite(imind,cm,'1.gif', 'gif','WriteMode','append'); 
    end 
end

%% "Mean face" of a population
Files=dir('frontalimages_spatiallynormalized_part/*b.jpg');
avg=zeros(46,2);
for k=1:length(Files)
    FileNames=Files(k).name;
    fir=strcat(FileNames(1:end-4),'.pts');
    fir=strcat('frontalshapes_manuallyannotated_46points/',fir);
    FileId=fopen(fir);
    npoints=textscan(FileId,'%s %f',1,'HeaderLines',1);
    points=textscan(FileId,'%f %f',npoints{2},'MultipleDelimsAsOne',2,'Headerlines',2);
    Y=cell2mat(points);
    avg=avg+Y;
end
avg=avg./length(Files);

%% Show the average face shape
x=avg(:,1);
y=avg(:,2);
DT = delaunay(x,y);
triplot(DT,x,y);

%% Morph each of the faces in the dataset into the average shape
Files=dir('frontalimages_spatiallynormalized_part/*a.jpg');
for k=1:length(Files)
FileNames=Files(k).name;
fixed=imread(strcat('frontalimages_spatiallynormalized_part/',FileNames));
[X,Y]=meshgrid(1:size(fixed,2),1:size(fixed,1));
X1=zeros(size(X));
Y1=zeros(size(Y));
fir=strcat(FileNames(1:end-4),'.pts');
fir=strcat('frontalshapes_manuallyannotated_46points/',fir);
FileId=fopen(fir);
npoints=textscan(FileId,'%s %f',1,'HeaderLines',1);
points=textscan(FileId,'%f %f',npoints{2},'MultipleDelimsAsOne',2,'Headerlines',2);
Y_n=cell2mat(points);
% x_n=Y_n(:,1);
% y_n=Y_n(:,2);
% DT_n = delaunay(x_n,y_n);
% tri_area=zeros(size(fixed));
for i=1:size(DT,1)
    tri2_pts=ones(3,3);
    tri1_pts=tri2_pts;
    N=avg(DT(i,:),:);
    tri1_pts(1:2,:)=(N)';
    BW = roipoly(fixed,N(:,1),N(:,2));
    tri2_pts(1:2,:)=(Y_n(DT(i,:),:))';
    T=computeAffine(tri1_pts,tri2_pts);
    X1=X1+(T(1,1)*X+T(1,2)*Y+T(1,3)).*BW;
    Y1=Y1+(T(2,1)*X+T(2,2)*Y+T(2,3)).*BW;
end
% for i=1:size(DT_n,1)
%     N2=Y_n(DT_n(i,:),:);
%     BW2 = roipoly(fixed,N2(:,1),N2(:,2));
%     tri_area=tri_area+BW2;
% end
fixed_mid = interp2(X,Y,(im2double(fixed)),X1,Y1);
% imwrite(fixed_mid,FileNames);
% imwrite(im2double(fixed).*tri_area,strcat(FileNames(1:end-4),'_org.jpg'));
if k==1
    I=fixed_mid;
else
    I=I+fixed_mid;
end
end
I=I./length(Files);
imshow(I)

%% naive average
Files=dir('frontalimages_spatiallynormalized_part/*a.jpg');
for k=1:length(Files)
    FileNames=Files(k).name;
    fixed=imread(strcat('frontalimages_spatiallynormalized_part/',FileNames));
    fixed=im2double(fixed);
    if k==1
        I=fixed;
    else
        I=I+fixed;
    end
end
I=I./length(Files);
imshow(I)

%% warp my face (keypoints selection)
moving = rgb2gray(imread('A1.jpg'));
fixed = imread('14.jpg');
% cpselect('A1.jpg','14.jpg');

%% change between my photo and the average
[X,Y]=meshgrid(1:size(fixed,2),1:size(fixed,1));
X1=zeros(size(X));
Y1=zeros(size(Y));
load('fixpoint1.mat');
load('movingpoint1.mat');
x=movingPoints1(:,1);
y=movingPoints1(:,2);
DT = delaunay(x,y);
for i=1:size(DT,1)
    tri2_pts=ones(3,3);
    tri1_pts=tri2_pts;
    N=movingPoints1(DT(i,:),:);
    tri1_pts(1:2,:)=(N)';
    BW = roipoly(fixed,N(:,1),N(:,2));
    tri2_pts(1:2,:)=(fixedPoints1(DT(i,:),:))';
    T=computeAffine(tri1_pts,tri2_pts);
    X1=X1+(T(1,1)*X+T(1,2)*Y+T(1,3)).*BW;
    Y1=Y1+(T(2,1)*X+T(2,2)*Y+T(2,3)).*BW;
end
fixed_mid(:,:) = interp2(X,Y,(im2double(fixed(:,:))),X1,Y1);
figure;hold on;
imshow(fixed_mid);
hold off;

%% extrapolation
[X,Y]=meshgrid(1:size(fixed,2),1:size(fixed,1));
X1=zeros(size(X));
Y1=zeros(size(Y));
load('fixpoint1.mat');
load('movingpoint1.mat');
alpha=-0.2;
newpoints=alpha*fixedPoints1+(1-alpha)*movingPoints1;
x=newpoints(:,1);
y=newpoints(:,2);
DT = delaunay(x,y);
for i=1:size(DT,1)
    tri2_pts=ones(3,3);
    tri1_pts=tri2_pts;
    N=newpoints(DT(i,:),:);
    tri1_pts(1:2,:)=(N)';
    BW = roipoly(fixed,N(:,1),N(:,2));
    tri2_pts(1:2,:)=(movingPoints1(DT(i,:),:))';
    T=computeAffine(tri1_pts,tri2_pts);
    X1=X1+(T(1,1)*X+T(1,2)*Y+T(1,3)).*BW;
    Y1=Y1+(T(2,1)*X+T(2,2)*Y+T(2,3)).*BW;
end
moving_mid(:,:) = interp2(X,Y,(im2double(moving(:,:))),X1,Y1);
figure;hold on;
imshow(moving_mid);
hold off;

%% trump age progressing
load('tufix1.mat');
load('tumov1.mat');
moving = imread('trump1.jpg');
fixed = imread('trump2.jpg');
h = figure;
for t=0:0.1:1
    morphed_im = morph(fixed, moving, tufix1, tumov1, 0, t, t);
    imshow(morphed_im);
    drawnow
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    if t == 0 
        imwrite(imind,cm,'2.gif', 'gif','Loopcount',inf); 
    else 
        imwrite(imind,cm,'2.gif', 'gif','WriteMode','append'); 
    end 
end
load('tufix2.mat');
load('tumov2.mat');
fixed2 = imread('trump3.jpg');
for t=0.1:0.1:1
    morphed_im = morph(fixed2, fixed, tufix2, tumov2, 0, t, t);
    imshow(morphed_im);
    drawnow
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    imwrite(imind,cm,'2.gif', 'gif','WriteMode','append');
end

%% PCA
clear;clc;
listing = dir("frontalimages_spatiallynormalized_part/*a.jpg");
name={listing.name};
whole=[];
for i=1:length(name)
    img=imread(strcat('frontalimages_spatiallynormalized_part/',char(name(i))));
    img=im2double(img);
    img=reshape(img,1,[]);
    whole = cat(1,whole,img);
end
whole=rescale(whole);
whole=whole';

%%
[U,S,V] = svd(whole,'econ');

%%
figure;hold on;
for i=1:6
    subplot(2,3,i);
    imshow(imadjust(reshape(U(:,i),[300,250])));
end
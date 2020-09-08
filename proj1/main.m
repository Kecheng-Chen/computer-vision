% CS194-26 (cs219-26): Project 1, starter Matlab code
% Kecheng Chen
clear;clc;
% name of the input file
imname = 'icon.tif';

% read in the image
fullim = imread(imname);
[a,b]=size(fullim);
%%
% convert to double matrix (might want to do this later on to same memory)
fullim = im2double(fullim);

% compute the height of each part (just 1/3 of total)
height = floor(size(fullim,1)/3);
% separate color channels
per=0.1;
B_org0 = fullim(1:height,:);
G_org0 = fullim(height+1:height*2,:);
R_org0 = fullim(height*2+1:height*3,:);
[r,c]=size(B_org0);
left=round(c*per);
right=c-left;
top=round(per*r);
bottom=r-top;
B_org0=B_org0(top:bottom,left:right);
G_org0=G_org0(top:bottom,left:right);
R_org0=R_org0(top:bottom,left:right);
B_org=rescale(B_org0);
G_org=rescale(G_org0);
R_org=rescale(R_org0);
% figure;
% imhist(G_org)
G_org=histeq(G_org,imhist(B_org));
R_org=histeq(R_org,imhist(B_org));
% figure;
% imhist(G_org)
% subplot(1,3,1), imshow(B);
% subplot(1,3,2), imshow(G);
% subplot(1,3,3), imshow(R);
displacement=zeros(2,2);
%% For jpg, if not please skip
B=B_org;
G=G_org;
R=R_org;
mean_B=mean(B,'all');
mean_G=mean(G,'all');
mean_R=mean(R,'all');
max1=-2;
max2=-2;
n=size(B);
temp1=[0,0];
temp2=[0,0];
bound_i=-15:15;
bound_j=-15:15;
for i=bound_i
    for j=bound_j
        score1=sum((B-mean_B).*(circshift(G,[i,j])-mean_G),'all')/...
                 sqrt(sum(((B-mean_B).^2),'all').*sum(((circshift(G,[i,j])-mean_G).^2),'all'));
        score2=sum((B-mean_B).*(circshift(R,[i,j])-mean_R),'all')/...
                 sqrt(sum(((B-mean_B).^2),'all').*sum(((circshift(R,[i,j])-mean_R).^2),'all'));
        if score1>max1
           max1 = score1;
           temp1=[i,j];
        end
        if score2>max2
           max2 = score2;
           temp2 = [i,j];
        end
    end
end
displacement(1,:)=(displacement(1,:)+temp1)*1;
displacement(2,:)=(displacement(2,:)+temp2)*1;

%% For tif, if not please skip
tic
% Align the images
% Functions that might be useful to you for aligning the images include: 
% "circshift", "sum", and "imresize" (for multiscale)
%%%%%aG = align(G,B);
%%%%%aR = align(R,B);
%website:http://graphics.cs.cmu.edu/courses/15-463/2004_fall/www/Papers/MSR-TR-2004-92-Sep27.pdf
%normalized cross-correlation
%pynum=round(log(min(size(B_org))/60))+1;
pynum=4;
%-round(size(B,2)/2):round(size(B,2)/2)
%-round(size(B,1)/2):round(size(B,1)/2)
%website:https://www.mathworks.com/help/images/ref/imresize.html
%imresize
% mean_B=mean(B_org,'all');
% mean_G=mean(G_org,'all');
% mean_R=mean(R_org,'all');

for k=1:pynum
    B=imresize(B_org,1/(2^(pynum-k+1)));
    G=circshift(imresize(G_org,1/(2^(pynum-k+1))),displacement(1,:));
    R=circshift(imresize(R_org,1/(2^(pynum-k+1))),displacement(2,:));
    mean_B=mean(B,'all');
    mean_G=mean(G,'all');
    mean_R=mean(R,'all');
    max1=-2;
    max2=-2;
%     max1=sum((B-mean_B).*(G-mean_G),'all')/...
%                  sqrt(sum(((B-mean_B).^2),'all').*sum((G-mean_G).^2,'all'));
%     max2=sum((B-mean_B).*(R-mean_R),'all')/...
%                  sqrt(sum(((B-mean_B).^2),'all').*sum((R-mean_R).^2,'all'));
%     G=histeq(G,imhist(B));
%     R=histeq(R,imhist(B));
    n=size(B);
    temp1=[0,0];
    temp2=[0,0];
    if k==1
        bound_i=-15:15;
        bound_j=-15:15;
    else
        bound_i=-5:5;
        bound_j=-5:5;
%         bound_i=-120:8:120;
%         bound_j=-120:8:120;
    end
    
%     Gmag_B = Prewitt_edge(B);
    
    for i=bound_i
        for j=bound_j
%             score1=sum((B-circshift(G,[i,j])).^2,'all')/(n(1)*n(2));
%             score2=sum((B-circshift(R,[i,j])).^2,'all')/(n(1)*n(2));

%             score1=(sum((edge(B,'canny')-edge(circshift(G,[i,j]),'canny')).^2,'all'))/(n(1)*n(2));
%             score2=(sum((edge(B,'canny')-edge(circshift(R,[i,j]),'canny')).^2,'all'))/(n(1)*n(2));

%             Gmag_G = Prewitt_edge(circshift(G,[i,j]));
%             Gmag_R = Prewitt_edge(circshift(R,[i,j]));
%             score1=sum((Gmag_B-Gmag_G).^2,'all')/(n(1)*n(2));
%             score2=sum((Gmag_B-Gmag_R).^2,'all')/(n(1)*n(2));
            
            score1=sum((B-mean_B).*(circshift(G,[i,j])-mean_G),'all')/...
                 sqrt(sum(((B-mean_B).^2),'all').*sum(((circshift(G,[i,j])-mean_G).^2),'all'));
            score2=sum((B-mean_B).*(circshift(R,[i,j])-mean_R),'all')/...
                 sqrt(sum(((B-mean_B).^2),'all').*sum(((circshift(R,[i,j])-mean_R).^2),'all'));
            if score1>max1
                max1 = score1;
                temp1=[i,j];
            end
            if score2>max2
                max2 = score2;
                temp2 = [i,j];
            end
        end
    end
    if k~=1+pynum
        displacement(1,:)=(displacement(1,:)+temp1)*2;
        displacement(2,:)=(displacement(2,:)+temp2)*2;
    else
        displacement(1,:)=displacement(1,:)+temp1;
        displacement(2,:)=displacement(2,:)+temp2;
    end
end

toc
% open figure
%% figure(1);

% create a color image (3D array)
% ... use the "cat" command
tdarray=cat(3,cat(3,circshift(R_org,displacement(2,:)),(circshift(G_org,displacement(1,:)))),B_org);
% show the resulting image
% ... use the "imshow" command
% save result image
imshow(tdarray);
%%
imwrite(tdarray,'V Ital?i.jpg');
%% 
imwrite(edge(B_org0,'canny'),'edge1.jpg');
imwrite(edge(B_org0,'Prewitt'),'edge2.jpg');
%% edge
imshowpair(edge(B_org0,'canny'),edge(B_org0,'Prewitt'),'montage')
%% gradient
[Gmag, Gdir] = imgradient(B_org0,'prewitt');
imwrite(Gmag,'grad.jpg');
%% automatic whitebalancing
rgbImage = imread('emir_ncc.jpg');
imwrite(rgbImage,'rgbImage1.jpg');
grayImage = rgb2gray(rgbImage);
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);
meanR = mean2(redChannel);
meanG = mean2(greenChannel);
meanB = mean2(blueChannel);
meanGray = mean2(grayImage);
redChannel = uint8(double(redChannel) * meanGray / meanR);
greenChannel = uint8(double(greenChannel) * meanGray / meanG);
blueChannel = uint8(double(blueChannel) * meanGray / meanB);
rgbImage = cat(3, redChannel, greenChannel, blueChannel);
imwrite(rgbImage,'rgbImage2.jpg');
%% gray world white balancing
rgbImage = imread('monastery_ssd.png');
imwrite(rgbImage,'rgbImage1.jpg');
illuminant=illumgray(rgb2lin(rgbImage),10);
B_lin = chromadapt(rgb2lin(rgbImage),illuminant,'ColorSpace','linear-rgb');
B = lin2rgb(B_lin);
imshow(B)
imwrite(B,'rgbImage2.jpg');
%% cropping
Image = fullim(1:height,:);
Image(Image==1)=0;
per=0.1;
[r,c]=size(Image);
left=round(c*per);
right=c-left;
top=round(per*r);
bottom=r-top;
J=stdfilt(Image);
ind=find(J>0.5);
[row,col] = ind2sub(size(J),ind);
Image=Image(max(row(row<top),[],'all'):min(row(row>bottom),[],'all'),...
    max(col(col<left),[],'all'):min(col(col>right),[],'all'));
imshow(Image)
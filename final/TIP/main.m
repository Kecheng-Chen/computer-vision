%% here is the GUI for selecting the up-left and down-right vertex, and vanishing point

clear;clc;
% Project 6, Tour Into the Picture
% Sample startup code by Alyosha Efros (so it's buggy!)
%
% We read in an image, get the 5 user-speficied points, and find
% the 5 rectangles.  

% read in sample inage
im = imread('Oxford.jpg');

% Run the GUI in Figure 1
figure(1);
[vx,vy,irx,iry,orx,ory] = TIP_GUI(im);

% Find the cube faces and compute the expended image
[bim,bim_alpha,vx,vy,ceilrx,ceilry,floorrx,floorry,...
    leftrx,leftry,rightrx,rightry,backrx,backry] = ...
    TIP_get5rects(im,vx,vy,irx,iry,orx,ory);

%% display the result from GUI

% display the expended image
figure(2);
imshow(bim);
% Here is one way to use the alpha channel (works for 3D plots too!)
alpha(bim_alpha);

% Draw the Vanishing Point and the 4 faces on the image
figure(2);
hold on;
plot(vx,vy,'w*');
plot([ceilrx ceilrx(1)], [ceilry ceilry(1)], 'y-');
plot([floorrx floorrx(1)], [floorry floorry(1)], 'm-');
plot([leftrx leftrx(1)], [leftry leftry(1)], 'c-');
plot([rightrx rightrx(1)], [rightry rightry(1)], 'g-');
hold off;

%%  3D construction from single image

% sample code on how to display 3D sufraces in Matlab
figure(3);
% define a surface in 3D (need at least 6 points, for some reason)
ratio=(max(backry)-min(backry))/(max(backrx)-min(backrx));
planex = [0 0 0; 0 0 0];
planey = [-1/ratio 0 1/ratio; -1/ratio 0 1/ratio]./2;
planez = [1 1 1; 0 0 0];
% create the surface and texturemap it with a given image
warp(planex,planey,planez,bim(backry(1):backry(3),backrx(1):backrx(2),:));
% some alpha-channel magic to make things transparent
% alpha(bim_alpha);
% alpha('texture');

n=1;
hold on;
planex = [-2 -1 0; -2 -1 0]./n;
planey = [-1 -1 -1; -1 -1 -1]./ratio./2;
planez = [1 1 1; 0 0 0];
im1=warpckc(leftrx,leftry,bim);
warp(planex,planey,planez,im1);

% planex = [-2 -2 -2; 0 0 0]./n;
% planey = [-1 0 1; -1 0 1]./ratio./2;
% planez = [1 1 1; 1 1 1];
% im2=warpckc(ceilrx,ceilry,bim);
% warp(planex,planey,planez,im2);

planex = [0 0 0; -2 -2 -2]./n;
planey = [-1 0 1; -1 0 1]./ratio./2;
planez = [0 0 0; 0 0 0];
im3=warpckc(floorrx,floorry,bim);
warp(planex,planey,planez,im3);

planex = [0 -1 -2; 0 -1 -2]./n;
planey = [1 1 1; 1 1 1]./ratio./2;
planez = [1 1 1; 0 0 0];
im4=warpckc(rightrx,rightry,bim);
warp(planex,planey,planez,im4);

% foreground object add to the scene
% I = imread('1.jpg');
% load('mask.mat');
% planex = [-1 -1 -1; -1 -1 -1]./n;
% planey = [-2 0 2;-2 0 2]./ratio./2;
% planez = [1 1 1; 0 0 0]-0.16;
% h=warp(planex,planey,planez,I);
% set(h,'FaceAlpha',  'texturemap', 'AlphaDataMapping', 'none', 'AlphaData',mask);

hold off;
%alpha scaled

% Some 3D magic...
axis equal;  % make X,Y,Z dimentions be equal
axis vis3d;  % freeze the scale for better rotations
axis off;    % turn off the stupid tick marks
camproj('perspective');  % make it a perspective projection
% use the "rotate 3D" button on the figure or do "View->Camera Toolbar"
% to rotate the figure
% or use functions campos and camtarget to set camera location 
% and viewpoint from within Matlab code

%% foreground object processing

I = imread('1.jpg');
% imshow(I)
% h=drawpolygon;
% mask = createMask(h);
% figure;
% imshow(mask)
% drawrectangle
% for i=1:3
%     J(:,:,i) = regionfill(I(:,:,i),mask);
% end
% figure;
% imshow(J);
% imshow(im2double(I).*mask);
planex = [0 0 0; 0 0 0];
planey = [-1 0 1;-1 0 1];
planez = [1 1 1; 0 0 0];
h=warp(planex,planey,planez,I);
set(h,'FaceAlpha',  'texturemap', 'AlphaDataMapping', 'none', 'AlphaData',mask);

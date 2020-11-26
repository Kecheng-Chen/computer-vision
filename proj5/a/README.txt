#Introduction of functions

1. H = computeH(im1_pts,im2_pts)
compute homography matrix

2. imwarped = warpImage(im,H)
warp the image with input image and homography matrix

3. [imwarped,bb] = warpImage_new(im,H)
same as the above but output bounding box for image blending

4. imarray=pyramids2(im,N,method)
implementation of laplacian pyramid

#mat file

fixedpoint1.mat: control points on 2.jpg
movingpoint1.mat: control points on 1.jpg
movingpoint1_adjust.mat: adjusted control points on 1.jpg
x.mat, y.mat: coordinates of control points selected on church1.jpg
x2.mat, y2.mat: coordinates of control points selected on church2.jpg
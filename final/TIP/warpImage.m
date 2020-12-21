function imwarped = warpImage(im,H,rx,ry)
% [m,n,z] = size(im);
% M=H*[1 n 1 n;1 1 m m;1 1 1 1];
M=H*[rx+1;ry+1;1 1 1 1];
bb = [round(min(M(1,:)./M(3,:))) round(max(M(1,:)./M(3,:)))...
    round(min(M(2,:)./M(3,:))) round(max(M(2,:)./M(3,:)))];
bb_xmin = bb(1);
bb_xmax = bb(2);
bb_ymin = bb(3);
bb_ymax = bb(4);
[U,V] = meshgrid(bb_xmin:bb_xmax,bb_ymin:bb_ymax);
Hi = inv(H);
u = U(:);
v = V(:);
x1 = Hi(1,1) * u + Hi(1,2) * v + Hi(1,3);
y1 = Hi(2,1) * u + Hi(2,2) * v + Hi(2,3);
w1 = 1./(Hi(3,1) * u + Hi(3,2) * v + Hi(3,3));
U(:) = x1 .* w1;
V(:) = y1 .* w1;
[nrows, ncols] = size(V);
imwarped(nrows,ncols,3)=1;
imwarped(:,:,1) = interp2(im(:,:,1),U,V,'cubic');
imwarped(:,:,2) = interp2(im(:,:,2),U,V,'cubic');
imwarped(:,:,3) = interp2(im(:,:,3),U,V,'cubic');
end
function H = computeH(im1_pts,im2_pts)
n=size(im1_pts,1);
A = zeros(2*n, 9);
for i=1:n
    A(2*i-1,:)=[-im1_pts(i,1) -im1_pts(i,2) -1 0 0 0 im2_pts(i,1)*im1_pts(i,1) im2_pts(i,1)*im1_pts(i,2) im2_pts(i,1)];
    A(2*i,:)=[0 0 0 -im1_pts(i,1) -im1_pts(i,2) -1 im2_pts(i,2)*im1_pts(i,1) im2_pts(i,2)*im1_pts(i,2) im2_pts(i,2)];
end
[~, ~, V] = svd(A);
H = reshape(V(:,end)/norm(V(:,end)),3,3)';
end
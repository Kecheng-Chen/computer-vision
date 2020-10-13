function morphed_im = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac)
    newpoints=warp_frac*im1_pts+(1-warp_frac)*im2_pts;
    x=newpoints(:,1);
    y=newpoints(:,2);
    DT = delaunay(x,y);
    [X,Y]=meshgrid(1:size(im1,2),1:size(im1,1));
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
        BW = roipoly(im1,N(:,1),N(:,2));
        tri2_pts(1:2,:)=(im1_pts(DT(i,:),:))';
        tri3_pts(1:2,:)=(im2_pts(DT(i,:),:))';
        T=computeAffine(tri1_pts,tri2_pts);
        T2=computeAffine(tri1_pts,tri3_pts);
        X1=X1+(T(1,1)*X+T(1,2)*Y+T(1,3)).*BW;
        Y1=Y1+(T(2,1)*X+T(2,2)*Y+T(2,3)).*BW;
        X2=X2+(T2(1,1)*X+T2(1,2)*Y+T2(1,3)).*BW;
        Y2=Y2+(T2(2,1)*X+T2(2,2)*Y+T2(2,3)).*BW;
    end
    mid1=zeros(size(im1));
    for i=1:3
        mid1(:,:,i) = interp2(X,Y,(im2double(im1(:,:,i))),X1,Y1);
    end
    mid2=zeros(size(im2));
    for i=1:3
        mid2(:,:,i) = interp2(X,Y,(im2double(im2(:,:,i))),X2,Y2);
    end
    morphed_im=dissolve_frac*mid1+(1-dissolve_frac)*mid2;
end
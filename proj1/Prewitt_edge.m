function image=Prewitt_edge(image_org)
    image = zeros(size(image_org));
    Mx = [-1 0 1; -1 0 1; -1 0 1]; 
    My = [-1 -1 -1; 0 0 0; 1 1 1];
    for i = 1:size(image_org, 1)-2 
        for j = 1:size(image_org, 2)-2
            Gx = sum(sum(Mx.*image_org(i:i+2, j:j+2))); 
            Gy = sum(sum(My.*image_org(i:i+2, j:j+2))); 
            image(i+1, j+1) = sqrt(Gx.^2 + Gy.^2);
        end
    end
end

%source:https://www.geeksforgeeks.org/matlab-image-edge-detection-using-prewitt-operator-from-scratch/
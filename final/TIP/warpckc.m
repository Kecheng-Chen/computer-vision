function im=warpckc(rx,ry,bim)
H = computeH(cat(1,rx+1,ry+1)',[1,1;1000,1;1000,1000;1,1000]);
im = warpImage(double(bim),H,rx,ry);
end
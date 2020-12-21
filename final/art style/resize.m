imname = './im5/download.png';
taj = imread(imname);
taj = im2double(taj);

sharped = taj(12:227,35:251,:);
imwrite(sharped, "./im5/bad.jpg");
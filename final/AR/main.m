%% Point tracking
clear;clc;
vi = VideoReader('1.mp4');
A=textread('array.txt','','headerlines',0);
point_array=zeros(41,2,vi.NumFrames);
A(:,1)=A(:,1)/1920*640;
A(:,2)=A(:,2)/1080*368;
A([1,8,9,14,16,17,24,25,32,33,34,35,36,43,44,45,46,47,54,55,56,57,58,65],:)=[];
point_array(:,:,1)=A;

objectFrame = readFrame(vi);
tracker = vision.PointTracker('MaxBidirectionalError',1,'MaxIterations',50,'NumPyramidLevels',4);
initialize(tracker,A,objectFrame);

i=0;
while hasFrame(vi)
      i=i+1;
      frame = readFrame(vi);
      [points,validity] = tracker(frame);
      figure(1);
      imshow(frame); hold on;
      scatter(points(validity, 1),points(validity, 2),200,'r.');
      point_array(:,:,i+1)=points(validity, :);
      hold off
%       F(i) = getframe(gcf);
%       drawnow
end
% writerObj = VideoWriter('try4.avi');
% writerObj.FrameRate = vi.FrameRate;
% open(writerObj);
% for i=1:length(F)
%     frame = F(i) ;    
%     writeVideo(writerObj, frame);
% end
% close(writerObj);

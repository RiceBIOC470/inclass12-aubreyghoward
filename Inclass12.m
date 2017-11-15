%Inclass 12. 
%GB comments
1) 100
2) 100
3) 100
4) 100
Overall 100

clear all
% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 

fileID = '011917-wntDose-esi017-RI_f0016.tif';
reader = bfGetReader(fileID);
reader.getSizeC;
reader.getSizeZ;
reader.getSizeT;
 
chan = 1;
time = 30; 
zplane = 1;

iplane = reader.getIndex(zplane -1,chan-1,time-1)+1;
img1 = bfGetPlane(reader,iplane);

chan = 2;
iplane = reader.getIndex(zplane -1,chan-1,time-1)+1;% This code is for the Nuclei Chanel
img2 = bfGetPlane(reader,iplane);
%figure; imshow(img,[500, 600]);


img_sm = imfilter(img2,fspecial('gaussian',4,2));
img_bg = imopen(img_sm,strel('disk',100));
img_sm_bg1 = imsubtract(img_sm,img_bg);
%figure; imshow(img_sm_bg1,[0 950])

img_sm = imfilter(img1,fspecial('gaussian',4,2));% This code is for the Nuclei Chanel
img_bg = imopen(img_sm,strel('disk',100));
img_sm_bg2 = imsubtract(img_sm,img_bg);
%figure; imshow(img_sm_bg2,[0 950])

% 2. threshold this image to get a mask that marks the cell nuclei. 

img_msk1 = img_sm_bg1 > 80;
%figure;imshow(img_msk1, []);

img_msk2 = img_sm_bg2 > 80;% This code is for the Nuclei Chanel
%figure;imshow(img_msk2, []);

img2show = cat(3,imadjust(img_sm_bg1),zeros(size(img_msk1)),imadjust(img_sm_bg2));
%figure;imshow(img2show);

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

%Chanel 1
img_msk1 = imdilate(img_msk1,strel('disk',5));
img_msk1 = imerode(img_msk1,strel('disk',5));
img_msk1 = imerode(img_msk1,strel('disk',10));
img_msk1 = imdilate(img_msk1,strel('disk',10));
%figure;imshow(img_msk1,[]);

%Chanel 2
img_msk2 = imerode(img_msk2,strel('disk',10));
img_msk2 = imdilate(img_msk2,strel('disk',10));
img_msk2 = imerode(img_msk2,strel('disk',10));
img_msk2 = imdilate(img_msk2,strel('disk',10));
%figure;imshow(img_msk2,[]);


% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other

% msk_props1 = regionprops(img_msk1,'Area','Centroid','Image','PixelIdxList');
% msk_props2 = regionprops(img_msk1,'Area','Centroid','Image','PixelIdxList');
% cell_props1 = regionprops(img_sm_bg1,'Area','Centroid','Image','PixelIdxList');
% cell_props2 = regionprops(img_sm_bg2,'Area','Centroid','Image','PixelIdxList');
%figure;hist([msk_properties.Area]);
%figure;hist([cell_properties.Area]);

cell_props1 = regionprops(img_msk1,img_sm_bg1,'MeanIntensity','MaxIntensity','PixelValues','Area','Centroid');
cell_props2 = regionprops(img_msk1,img_sm_bg2,'MeanIntensity','MaxIntensity','PixelValues','Area','Centroid');

disp('start cell props1 check')
intensities1 = [cell_props1.MeanIntensity];
intensities2 = [cell_props2.MeanIntensity];

figure;
plot(intensities1,intensities2,'r.','MarkerSize',18)
xlabel('Intensities from Ch1','FontSize',28)
ylabel('Intensities from Ch2','FontSize',28)

disp('done')

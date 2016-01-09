close all;clear all;clc

disp(['SimpleGabor Toolbox Version: ' sg_version]);

%
% Read and normalise image
fprintf('Reading an input image...');
img = imread('./src/train/0000000001.jpg');
img = squeeze(img(:,:,1));
img = double(img)/255;
fprintf('Done!\n');

%fh = figure;
%colormap gray

%
% Create Gabor filter bank
fprintf('Creating Gabor filter bank with selected parameters...');
gaborBank = sg_createfilterbank(size(img),1/4,3,4,'pf',0.9);%f,o
fprintf('Done!\n');

%
% Filter with the filter bank
fprintf('Filtering...');
fResp = sg_filterwithbank(img,gaborBank);
fResp2 = sg_filterwithbank(img,gaborBank, 'points', [100,60]);
% f = 3, o = 4
fprintf('Done!\n');

%
% Convert responses to simple 3-D matrix
fprintf('Convert responses to matrix form...');
%fResp = sg_resp2samplematrix(fResp);
G = sg_resp2samplematrix(fResp);
G2 = sg_resp2samplematrix(fResp2);
G3 = G(60,100,:);
G2(2,:) = G3(:).';
G4 = squeeze(G3);
fprintf('Done!\n');
return
%
% Normalise
fprintf('Normalise responses to reduce illumination effect...');
fResp = sg_normalizesamplematrix(fResp);
fprintf('Done!\n');

%
% Display responses
fprintf('Displaying input image and responses...');
subplot(1,3,1);
imagesc(img);
axis off
title('Input');
for featInd = 1:size(fResp,3)
  subplot(1,3,2);
  imagesc(squeeze(real(fResp(:,:,featInd))));
  axis off
  title('Real');
  subplot(1,3,3);
  imagesc(squeeze(imag(fResp(:,:,featInd))));
  axis off
  title('Imaginary');
  input('<RETURN>');
end;
fprintf('Done!\n');

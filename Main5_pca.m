%
% Third version extract 'ellipse' area as features (if extend==0 => single area)
% multi part (deform part=5)
%
close all;clear all;clc;

addpath( genpath('app') );
addpath( genpath('src') );
load( 'deformedTemplate');

%
% Variables
freq = 1/9;
m = 4; % freq
n = 4; % ori

%
% Part Variables
PART = 1;%size(deformedTemplate,1);
bayesS = cell( PART, 1 );
dTrain = cell( PART, 1 );

%% Training Stage
disp('----------Training Stage----------');
imsT = ReadImages('src/train',1);
imsTNum = length(imsT);
gaborBank = sg_createfilterbank(size(imsT{1}), ...
    freq, m, n, 'k', sqrt(3), 'verbose', 0);
Gs = cell( imsTNum, PART );
clear freq m n 

fprintf('Filtering...');tic
for part = 1 : PART
    % Create feature matrix Gs
    for idx = 1 : imsTNum
        imTFlr = sg_filterwithbank( imsT{idx}, gaborBank );
        imTFlr = sg_resp2samplematrix( imTFlr );
        imTFlr = sg_normalizesamplematrix( imTFlr );
        [rows, cals, z] = find( deformedTemplate{part, idx} );% centers
        %G_ = cell( 1, length(rows)-50 );
        G_ = cell( 1, 1 );
        for r = 1 : 1
            G_{r} = imTFlr(rows(r),cals(r),:);
            G_{r} = G_{r}(:).';
        end
        Gs{idx} = G_;
        clear G_ rows cals z r
    end
    clear idx imTFlr  
end
fprintf('Done!');
fprintf(['(elapsed time: ' num2str(toc) ' seconds)\n']);

fprintf('Training GMM...');tic
for part = 1 : PART    
    % Formate GMM input
    dTrain{ part } = [];
    for img = 1 : imsTNum % length of train imgs
        tmp = [];
        for idx = 1 : length( Gs{img} ) % ellipse area
            tmp = [ tmp ; [ real(Gs{img}{idx}(:)), imag(Gs{img}{idx}(:)) ] ];
        end
        
%         % PCA
%         tmp = tmp';
%         K = ( length(tmp) / length( Gs{img} ) );
%         [eigenVector,score,eigenvalue,tsquare] = princomp( tmp );
%         transMatrix = eigenVector(:,1:K);
%         tmp = tmp * transMatrix;
%         tmp = tmp';
        
        dTrain{part} = [ dTrain{part} ; tmp ];
    end
    cTrain = ones( length(dTrain{part}),1 );
    clear idx img tmp
    
    % Train FJ-GMM
    FJ_params = { 'Cmax', 15, 'thr', 50, 'animate', 0 };
    bayesS{part} = gmmb_create(dTrain{part}, cTrain, 'FJ', FJ_params{:});
    % Train EM-GMM
    %bayesS{part} = gmmb_create(dTrain{part}, cTrain, 'EM', 'components', 5, 'thr', 1e-8);

end
fprintf('Done!');
fprintf(['(elapsed time: ' num2str(toc) ' seconds)\n']);

clear part cTrain FJ_params

%% Testing Stage
disp('----------Testing Stage----------');
imsV = ReadImages('src/validation',1);
imsVNum = length(imsV);
pdfMaps = cell(imsVNum, PART);

for img = 1 : imsVNum
    disp(['----Detecting ' num2str(img) ' of ' num2str(imsVNum)]);tic
    for part = 1 : PART
        disp(['-Detecting part ' num2str(part)]);
        pdfMaps{img, part} = TestStage2_pca( imsV{img}, gaborBank, bayesS{part} );
    end
    disp(['elapsed time: ' num2str(toc) ' seconds']);
    
    % Write out figures
    for part = 1 : PART
        figure
        imagesc( pdfMaps{img,part} );
        set(gca,'XTick',[]) % Remove the ticks in the x axis
        set(gca,'YTick',[]) % Remove the ticks in the y axis
        set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
        saveas(gcf,['/Users/ful6ru04/Desktop/pdfMap_i' num2str(img) '_p' num2str(part) '.jpg'])
    end
    imwrite(imsV{img},['/Users/ful6ru04/Desktop/ori' num2str(img) '.jpg']);
    
end
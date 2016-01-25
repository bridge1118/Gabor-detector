function imsFlr = FilterImages( images, f, m, n )

%
% Output 
imsNum = length(images);
imsFlr = cell(imsNum,1);

%
% Create Gabor filter bank
gaborBank = ...
    sg_createfilterbank(size(images{1}), ...
    f, m, n, 'k', sqrt(3), 'verbose', 0);

%
% Filter with the filter bank
fprintf('Filtering...');
for idx = 1 : length(images)
    imsFlr{idx} = sg_filterwithbank( images{idx}, gaborBank );
    imsFlr{idx} = sg_resp2samplematrix( imsFlr{idx} );
    %imsFlr{idx} = sg_normalizesamplematrix( imsFlr{idx} );
end
fprintf('Done!\n');

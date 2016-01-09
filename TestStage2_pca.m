function [ pdfMap ] = TestStage2_pca( im, gaborBank, bayesS )

% PDF test (Bayesian case)
fprintf('Classfying...');
pdfMap = zeros( size(im,1), size(im,2) );
imFlr = sg_filterwithbank(im, gaborBank);
imFlr = sg_resp2samplematrix( imFlr );
imFlr = sg_normalizesamplematrix( imFlr );

for i = 1 : size(im, 1)
    for j = 1 : size(im, 2)
        % Feature matrix
        G = imFlr(i,j,:);
        G = G(:).';
        G = G(:);
        G = [ real(G), imag(G) ];
        
        % pdf
        pdfmat = gmmb_pdf( G, bayesS);
        pdfmat = gmmb_weightprior(pdfmat, bayesS);
        %pdfmat = gmmb_normalize( gmmb_weightprior(pdfmat', bayesS) );
        pdfmat2= sort( pdfmat, 'descend' );
        pdfmat2= pdfmat2(3:end-3);
        %pdfmat2= pdfmat2 ./ sqrt(sum(pdfmat2.^2));
        %pdfmat2 = pdfmat;
        pdfMap(i,j) = sum( pdfmat2(:) ) ;%/ length(pdfmat);
        
        clear tmp_feature pdfmat
    end
end
fprintf('Done!\n');
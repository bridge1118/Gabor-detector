function map = GetFeatureMap( im )

%
% Output var
Gtmp = zeros(m, n);



binSize = 8 ;
magnif = 3 ;
im = vl_imsmooth(im, sqrt((binSize/magnif)^2 - .25)) ;

%
% Extract feature space
for p = 1 : size(Gtmp,1)
    for q = 1 : size(Gtmp,2)
        Gtmp(p,q) = im(r,c,p*q);
    end
end

%
% Normalize
s = Gtmp.^2;
Gtmp = Gtmp ./ sqrt( sum(s(:)) );
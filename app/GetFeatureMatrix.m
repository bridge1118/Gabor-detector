function Gtmp = GetFeatureMatrix( im, r, c, m, n )

%
% Output var
Gtmp = zeros(m, n);

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
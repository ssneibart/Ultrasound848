function Y = TGC(X, alpha)

d = 1:size(X,1);
amp = 0.5*exp(alpha*d)';

Z = repmat(amp,[1,size(X,2)]);

Y = Z.*X;

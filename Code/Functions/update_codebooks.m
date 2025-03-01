function V = update_codebooks(varargin)
%evaluate the paramters
for i=1:2:length(varargin)
    eval([genvarname(varargin{i}) ' = varargin{i+1};']);
end

%% Batch SOM update
V = zeros(size(h,1),size(x,2));
S = h*(U*x);
A = h*(U*~isnan(x));
nonzero = find(A > 0);
V(nonzero) = S(nonzero)./A(nonzero);
end

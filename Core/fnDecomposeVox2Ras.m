function [a2fCRS, afScale] = fnDecomposeVox2Ras(a2fM)
% Given the Vox2RAS matrix. Decompose it back to cosine matrix and scale
% matrix using SVD decomposition
[u,s,v]=svd(a2fM);
a2fCRS = u*v';
afScale = diag(s);

return;



function a3fTransformation=fnResizeKeepAspect(fImageWidth,fImageHeight, fScreenWidth, fScreenHeight)
% Map [fImageWidth,fImageHeight] to [fScreenWidth, fScreenHeight]
% But keeps the aspect ratio.

% Try scaling by X
fScaleY = fImageHeight/fScreenHeight;
fProposedWidth = fImageWidth/fScaleY;
if fProposedWidth <= fScreenWidth
    % OK
    a3fTransformation = [fScaleY 0 0;
                         0 fScaleY 0;
                         0 0 1];
else
    fScaleX = fImageWidth/fScreenWidth;
%    fProposedHeight = fImageHeight/fScaleX;
    a3fTransformation = [fScaleX 0 0;
                         0 fScaleX 0;
                         0 0 1];    
end
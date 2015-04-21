function [xi, yi, placement_cancelled] = fnMyCreateWaitModePolygon(h_ax,finished_cmenu_text, X,Y)
%createWaitModePolygon creates a blocking instance of impoly.
% [XI,YI,PLACEMENT_CANCELLED] =
% createWaitModePolygon(H_AX,FINISHED_CMENU_TEXT) creates a blocking
% instance of impoly parented to H_AX. The context menu description of the
% end of placement gesture receives the label FINISHED_CMENU_TEXT. Once the
% polygon is placed, it returns [XI,YI] vertices of where the polygon was
% oriented and PLACEMENT_CANCELLED which signals whether placement was
% cancelled.

%   Copyright 2007-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $ $Date: 2009/12/02 06:43:26 $

% initialize to "identity" mask
[xi,yi] = deal([]);
h_poly = fnMyImpoly(h_ax, [X,Y]);
placement_cancelled = isempty(h_poly);
if placement_cancelled
    return;
end

pos = wait(h_poly);

abortedWaitMode = isempty(pos);
if abortedWaitMode
    placement_cancelled = true;
else
    xi = pos(:,1);
    yi = pos(:,2);
end
% We are done. Delete the polygon to clean up. Use isvalid to account for
% Cancel context menu item which will have already deleted the impoly
% instance.
if isvalid(h_poly)
    h_poly.delete();
end




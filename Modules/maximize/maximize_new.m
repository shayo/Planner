%MAXIMIZE  Maximize a figure window to fill the entire screen
%
% Examples:
%   maximize
%   maximize(hFig)
%
% Maximizes the current or input figure so that it fills the whole of the
% screen that the figure is currently on. This function is platform
% independent, but it does require findjobj to be on the MATLAB path. This
% can be downloaded from:
%   http://www.mathworks.com/matlabcentral/fileexchange/14317
%
%IN:
%   hFig - Handle of figure to maximize. Default: gcf.

function maximize_new(hFig)
if nargin < 1
    hFig = gcf;
end
try
    a = findjobj(hFig, 'property', 'maximized', 'flat', 'nomenu');
    a.maximized = 1;
catch
    error('maximize needs findjobj to be on the MATLAB path. findjobj can be downloaded from http://www.mathworks.com/matlabcentral/fileexchange/14317.');
end

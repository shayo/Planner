
function RotateChamberByFixedAmount()
global g_strctModule


prompt={'Rotate by X deg:'};
name='Chamber Rotation';
numlines=1;
defaultanswer={'0'};

answer=inputdlg(prompt,name,numlines,defaultanswer);
if ~isempty(answer)
    % rotation will be X/100 * pi, so we need to pass
    fnRotateChamber(g_strctModule.m_strctLastMouseDown.m_hAxes, str2num(answer{1})*500 / 180); %#ok
end
return;

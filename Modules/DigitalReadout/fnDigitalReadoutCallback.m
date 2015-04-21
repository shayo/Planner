function fnDigitalReadoutCallback(strCallback, varargin)

switch strCallback
    case 'PrepareForModuleSwitch'
        % Stop timer
        fnStopUpdateTimer();
    case 'ModuleSwitch'
        % Start timer
        fnStartUpdateTimer();
    case 'SetValue1NaN'
        fnSetValue1NaN();
    case 'SetValue2NaN'
        fnSetValue2NaN();
    case 'SetValue1'
        % as
        fnSetValue1();
    case 'SetValue2'
        fnSetValue2();
    case 'ResetCalibrate'
    case 'SelectEntry1'
    case 'SelectEntry2'    
    case 'Calibrate'
        fnCalibrateScale();
    case 'AppClose'
        fnStopUpdateTimer();
end

return;

function fnSetValue1NaN()
global g_strctModule 
iXIndex = get(g_strctModule.m_strctPanel.m_hCalib1List,'value');
g_strctModule.m_afCalibY1(iXIndex) = NaN;
fnInvalidateListBox();
return;

function fnSetValue2NaN()
global g_strctModule 
iXIndex = get(g_strctModule.m_strctPanel.m_hCalib2List,'value');
g_strctModule.m_afCalibY2(iXIndex) = NaN;
fnInvalidateListBox();
return;


function fnSetValue1()
global g_strctModule 
% Measure
N = 100; % Repeated measurements
afValues = zeros(1,N);
for k=1:N
    afValues(k) = fnDAQRedBox('GetAnalog',0);
end

iXIndex = get(g_strctModule.m_strctPanel.m_hCalib1List,'value');
g_strctModule.m_afCalibY1(iXIndex) = median(afValues);
fnInvalidateListBox();
return;

function fnSetValue2()
global g_strctModule 
% Measure
N = 100; % Repeated measurements
afValues = zeros(1,N);
for k=1:N
    afValues(k) = fnDAQRedBox('GetAnalog',1);
end

iXIndex = get(g_strctModule.m_strctPanel.m_hCalib2List,'value');
g_strctModule.m_afCalibY2(iXIndex) = median(afValues);
fnInvalidateListBox();
return;

function fnInvalidateListBox()
global g_strctModule
acStr1 = cell(1,length(g_strctModule.m_afCalibX));
acStr2 = cell(1,length(g_strctModule.m_afCalibX));
for k=1:length(g_strctModule.m_afCalibX)
    acStr1{k} = sprintf('%-8d %d',g_strctModule.m_afCalibX(k),g_strctModule.m_afCalibY1(k));
    acStr2{k} = sprintf('%-8d %d',g_strctModule.m_afCalibX(k),g_strctModule.m_afCalibY2(k));
end
set(g_strctModule.m_strctPanel.m_hCalib1List,'string',char(acStr1));
set(g_strctModule.m_strctPanel.m_hCalib2List,'string',char(acStr2));
return;


function fnStopUpdateTimer()
global g_strctModule 
if ~isempty(g_strctModule.m_hTimer)
    stop(g_strctModule.m_hTimer);
    g_strctModule.m_hTimer = [];
end
return;


function fnStartUpdateTimer()
global g_strctModule 
if ~isempty(g_strctModule.m_hTimer)
    return; % why should we start it if it is running?
end

g_strctModule.m_hTimer = timer('TimerFcn',@fnMeasureInvalidate, 'Period', 0.05,'ExecutionMode','fixedDelay');
start(g_strctModule.m_hTimer);

return;

function fnMeasureInvalidate(a,b)
global g_strctModule 
afValues = zeros(1,2);
N = 10;
for k=1:N
    afValues = afValues+fnDAQRedBox('GetAnalog',0:1);
end
afValues = afValues / N;
g_strctModule.m_a2fHistory(g_strctModule.m_iHistoryIndex,:) = afValues;
g_strctModule.m_iHistoryIndex = g_strctModule.m_iHistoryIndex + 1;
if g_strctModule.m_iHistoryIndex > size(g_strctModule.m_a2fHistory,1)
    g_strctModule.m_iHistoryIndex = 1;
end
set(g_strctModule.m_strctPanel.m_astrctReadOut(1).m_hStatusLine,'string', sprintf('RAW %d',round(afValues(1))));
set(g_strctModule.m_strctPanel.m_astrctReadOut(2).m_hStatusLine,'string', sprintf('RAW %d',round(afValues(2))));
set(g_strctModule.m_strctPanel.m_astrctReadOut(1).m_hCurve,'xdata', 1:g_strctModule.m_iHistoryIndex-1, 'ydata',g_strctModule.m_a2fHistory(1:g_strctModule.m_iHistoryIndex-1, 1));
set(g_strctModule.m_strctPanel.m_astrctReadOut(2).m_hCurve,'xdata', 1:g_strctModule.m_iHistoryIndex-1, 'ydata',g_strctModule.m_a2fHistory(1:g_strctModule.m_iHistoryIndex-1, 2));

if isfield(g_strctModule,'m_strctCalib1') && ~isempty(g_strctModule.m_strctCalib1)
    fAlpha1Deg = asin((afValues(1) - g_strctModule.m_strctCalib1.m_fOffset)/ g_strctModule.m_strctCalib1.m_fScale)/pi*180;
    set(g_strctModule.m_strctPanel.m_astrctReadOut(3).m_hStatusLine,'string', sprintf('%.2f Deg',fAlpha1Deg));
    
end


if isfield(g_strctModule,'m_strctCalib2') && ~isempty(g_strctModule.m_strctCalib2)
    fAlpha2Deg = asin((afValues(2) - g_strctModule.m_strctCalib2.m_fOffset)/ g_strctModule.m_strctCalib2.m_fScale)/pi*180;
    set(g_strctModule.m_strctPanel.m_astrctReadOut(4).m_hStatusLine,'string', sprintf('%.2f Deg',fAlpha2Deg));
    
end
return;

function fnCalibrateScale()
global g_strctModule 
g_strctModule.m_strctCalib1 = [];
g_strctModule.m_strctCalib2 = [];
for iIter=1:2
    if iIter == 1
        afYValues = g_strctModule.m_afCalibY1;
    else
        afYValues = g_strctModule.m_afCalibY2;
    end
    
aiValidEntries = find(~isnan(afYValues));
afX = g_strctModule.m_afCalibX(aiValidEntries);
afY = afYValues(aiValidEntries);
    iX0Index = find(afX == 0);
    if isempty(iX0Index)
        continue;
    end;
    fY0Value = afY(iX0Index);
    
    if iIter == 1
        afScales = linspace(100,500,10000);
    else
        afScales = -linspace(100,500,10000);
    end
    afOffsets = -5:5;

    a2fErrors = zeros(length(afOffsets),length(afScales));
    
    for j=1:length(afOffsets)
        afYrelative = afY-(fY0Value+afOffsets(j));
        for k=1:length(afScales)
            fScale = afScales(k);
            R = asin(afYrelative / fScale)/pi*180;
            E = sqrt(sum((R-afX).^2));
            a2fErrors(j,k)=E;
        end;
    end
    
    figure(iIter+1);
    plot(afScales,a2fErrors')
    
    [fMinError,iIndex] = min(a2fErrors(:));
    [iOffsetIndex,iScaleIndex]=ind2sub(size(a2fErrors),iIndex);
    fOptOffset = fY0Value + afOffsets(iOffsetIndex);
    fOptScale = afScales(iScaleIndex);
    fprintf('Optimal scale factor was computed to be %.3f, Optimal Offset is %.2f\n',fOptScale,afOffsets(iOffsetIndex));
    if iIter == 1
        g_strctModule.m_strctCalib1.m_fScale = fOptScale;
        g_strctModule.m_strctCalib1.m_fOffset = fOptOffset;
    else
        g_strctModule.m_strctCalib2.m_fScale = fOptScale;
        g_strctModule.m_strctCalib2.m_fOffset = fOptOffset;
    end
end
fprintf('Calibraiton Saved!\n');
save('DigitalReadOutCalibration.mat','g_strctModule');

return;

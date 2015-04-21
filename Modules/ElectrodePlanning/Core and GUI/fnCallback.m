
function fnCallback(a,b,strEvent,varargin) %#ok
global g_strctModule
feval(g_strctModule.m_hCallbackFunc,strEvent,varargin{:});
return;

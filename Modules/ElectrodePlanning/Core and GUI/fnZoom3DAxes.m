function fnZoom3DAxes(iDirection)
global g_strctModule
q = max(-.9, min(.9, iDirection/70));

%posOld = get(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,'CameraPosition');
camdolly(g_strctModule.m_strctPanel.m_strct3D.m_hAxes,0,0,q, 'f');

%     %If the dolly puts us too close to the target, undo the move:
%     dist = norm(get(haxes,'CameraPosition')-get(haxes,'CameraTarget'));
%     if dist > 3.3316e+003 || dist < 0.4
%         set(haxes,'CameraPosition',posOld);
%     end
   return;
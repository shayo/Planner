function [a3fHeat, a2fAlpha] = fnOverlayContrastTransform(a2fI)
global g_strctModule

 [a3fHeat, a2fAlpha] = fnOverlayTransformAux(a2fI, g_strctModule.m_strctOverlay);
 return;
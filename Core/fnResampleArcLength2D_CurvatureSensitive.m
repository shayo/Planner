function apt2fArcLength= fnResampleArcLength2D_CurvatureSensitive(apt2Trajectory, fCurvatureThreshold, fQuantizationPix)
% Assume Nx2
% Remove redundant vertices
abNonRedundant = [1>0;sqrt(sum((apt2Trajectory(2:end,:) - apt2Trajectory(1:end-1,:)).^2,2) ) > eps];
apt2Trajectory = apt2Trajectory(abNonRedundant,:);

a2fDiff = [apt2Trajectory(2:end,:)-apt2Trajectory(1:end-1,:)];
afLength = sqrt(a2fDiff(:,1).^2+a2fDiff(:,2).^2);
afCumLength = [0;cumsum(afLength)];
afEqualDistancePoints = linspace(0, afCumLength(end), ceil(afCumLength(end)/fQuantizationPix));
afResampledXValues = interp1(afCumLength, apt2Trajectory(:,1), afEqualDistancePoints);
afResampledYValues = interp1(afCumLength, apt2Trajectory(:,2), afEqualDistancePoints);
apt2fArcLength = [afResampledXValues', afResampledYValues'];
return;
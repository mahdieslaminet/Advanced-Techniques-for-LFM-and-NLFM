function [Angle,DeltaPhi , SLBflag] = AngleEstimation(sumABS,sumPhi,DiffAbs,diffPhi,Freq,ManualCalib,Ampcalibcoef,PhaseCalibcoef,SLBThr)
Nabs = 16;

%
% if ManualCalib == 0
%     [Ampcalibcoef , PhaseCalibcoef , SLBThr] = CalibLUT(Freq)
% 
% end

%% Calculation pf |Delta| / |Sigma|
Delta2Sigma_abs = fixpointud(round(DiffAbs./sumABS),0,Nabs);
Delta2Sigma_abs_Calib = fixpointud(Ampcalibcoef.*Delta2Sigma_abs,10,Nabs);

%%
DeltaPhi = diffPhi - sumPhi;
Pi =  round(pi*(2^(8-1)));
DeltaPhi(abs(DeltaPhi)>Pi) = DeltaPhi(abs(DeltaPhi)>Pi) - 2*pi*sign(DeltaPhi(abs(DeltaPhi)>Pi));
DeltaPhi(DeltaPhi == 402) = -402;
DeltaPhi              = DeltaPhi - PhaseCalibcoef;
DeltaPhi(abs(DeltaPhi)>Pi) = DeltaPhi (abs(DeltaPhi)>Pi) - 2*pi*sign(DeltaPhi(abs(DeltaPhi)>Pi));
DeltaPhi(DeltaPhi == 402) = -402;
SignDelta = sign(DeltaPhi);
SignDelta(SignDelta == 0) = 1;

Angle = -Delta2Sigma_abs_Calib.*SignDelta ;

SLBflag  = Delta2Sigma_abs_Calib > SLBThr;
end
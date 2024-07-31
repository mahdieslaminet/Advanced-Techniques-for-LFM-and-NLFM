function [Freq1,Freq2]  = FreqEstimation( sigin_phase)
fs = 1e9/2;
Res = 1e6;
Pi = round(pi*(2^(8-1)));
MaxFrError = 125;

% Delta Phi Calculation
Diff1 = sigin_phase - [sigin_phase(1) sigin_phase(1:end-1)];
Diff2 = sigin_phase - [sigin_phase(1:2) sigin_phase(1:end-2)];

%% limit Delta phi to -pi:pi

Diff1(abs(Diff1)>pi) = Diff1(abs(Diff1)>pi)  - 2*pi*sign(Diff1(abs(Diff1)>pi));
Diff2(abs(Diff2)>pi) = Diff2(abs(Diff2)>pi)  - 2*pi*sign(Diff2(abs(Diff2)>pi));

%% Matching FPGA
Diff1(Diff1 == 402) = -402;
Diff2(Diff2 == 402) = -402;

Freq1  = round(Diff1*81485/2^17);
Freq2  = round(Diff2*40472/2^17);

%% Resolve Ambgiguity
Fs = fs/Res;
Freq2((Freq1-Freq2) >= MaxFrError) = Freq2((Freq1-Freq2) >= MaxFrError) + Fs/2;
Freq2((Freq2-Freq1) >= MaxFrError) = Freq2((Freq2-Freq1) >= MaxFrError) - Fs/2;
Freq2(Freq2>207)     = 207;
Freq2(Freq2<-207)    = -207;


end
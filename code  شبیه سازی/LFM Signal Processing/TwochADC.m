function  [SignalHG,SignalLG] = TwochADC(Signal,noiseindex)


%%% Range1: -25:30  dBm
%%% Range1: -80:-20 dBm

K         = 1.38*10^-(23);
T         = 290;
F_HG      = 9;
F_LG      = 34;
PnoiseADC = -57 ; %dBm

%BW = 400 MHZ ----> input Variable


noiseHG = noiseindex.*sqrt(K*T*400e6*10^(F_HG/10)).*randn(1,length(Signal));
noiseLG = noiseindex.*sqrt(K*T*400e6*10^(F_LG/10)).*randn(1,length(Signal));
noiseADC = noiseindex.*10^((PnoiseADC-30)/20).*randn(1,length(Signal));

G_LG = 10^(-5/10);  % dB2POw(8-35)
G_HG = 10^(40/20);
Pfs = 1e-2; %10dBm
NB = 14;
Vfs = sqrt(2*Pfs);

SignalADC_HG = AtoD((Signal+noiseHG)*G_HG+noiseADC,NB,Vfs);
SignalHG     = fixpointud(SignalADC_HG,0,NB);

SignalADC_LG = AtoD((Signal+noiseLG)*G_LG+noiseADC,NB,Vfs);
SignalLG     = fixpointud(SignalADC_LG,0,NB);
end

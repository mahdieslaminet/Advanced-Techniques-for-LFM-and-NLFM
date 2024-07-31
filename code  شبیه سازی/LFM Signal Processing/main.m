clc;clearvars;close all;

%% Simulation Parameters

Fsampling      = 1e9;
SimulationTime = 100e-6;
t              = 0 : 1/Fsampling : SimulationTime-1/Fsampling;

%% Receiver Parameters

BeamWidth      = 40;
DifftoSumPhase = (90-(40+15))*pi/180;
LPF_BW = 400;
%% Target Parameters

pin             = [-60 -1000 -1000];
Radar.Amp       = sqrt(2)*10.^((pin-30)/20);
Radar.IF        = [750e6 550e6 850e6];
Radar.Bw        = [1e6 1e6 1];
Radar.Pw        = [1e-6 1e-6 10e-5];
Radar.Prf       = [1/16e-6 1/5e-6 6250];
Radar.SeekAngel = [0 0 0];
Radar.Phasecode = [0 0 10];
Radar.delay     = [0.5e-6 1.22e-6 0];

%% Jammer Parameters
Jammer.IF    = [750e6 603e6];
Jammer.Amp   = sqrt(2)*10.^(([-80 -70]-30)/20);
Jammer.Angle = [20 20];
Jammer.delay = [15e-6 50e-6];
Jammer.T_on  = [500e-6 600e-6];
Jammer.Type  = {'CW','Noise'};


%%Dsp Parameter
ManualCalib = 1;
AmpCalibcoef = 2^10;
PhaseCalibcoef = 0;
SLBThr =  2^13;


%% Target Generator

[SumTarget,DiffTarget] = TargetGenerator (Fsampling,SimulationTime,Radar,BeamWidth,DifftoSumPhase);
[SumJammer,DiffJammer] = JammerGenerator (Fsampling,SimulationTime,Jammer,BeamWidth,DifftoSumPhase);

SumSignal  = SumTarget  + SumJammer ;
DiffSignal = DiffTarget + DiffJammer;

figure(1);
plot(t,SumSignal);grid on;title('Sum Signal');xlabel('Time (S)'),ylabel('Power (W)');
figure(2);
plot(db(fft(SumSignal)));grid on;title('Sum Signal');ylabel('dB');
% 
% figure(3);
% plot(DiffSignal);grid on;title('Diff Signal');ylabel('dB');
% figure(4);
% plot(db(fft(DiffSignal)));grid on;title('Diff Signal');ylabel('dB');

%% ADC
noiseindex = 1;
[SigSumHG,SigSumLG]   = TwochADC(SumSignal,noiseindex) ; 
[SigDiffHG,SigDiffLG] = TwochADC(DiffSignal,noiseindex);

figure(3);
plot(t,SigSumHG);grid on;title('Sum Signal');xlabel('Time (S)'),ylabel('Power (W)');

%% NCO
NOutNCO    = 14;

SumDownHG  = NCOfix250(SigSumHG,NOutNCO);
SumDownLG  = NCOfix250(SigSumLG,NOutNCO);
DiffDownHG = NCOfix250(SigDiffHG,NOutNCO);
DiffDownLG = NCOfix250(SigDiffLG,NOutNCO);

figure(5);
plot(real(SumDownHG));grid on;
figure(6);
plot(db(fft(SumDownHG)));grid on;

%% LPF Filter
NoutFilter = 16;

Sum_HG_filt1 = LPFilter(SumDownHG,LPF_BW,NoutFilter);
Sum_LG_filt1 = LPFilter(SumDownLG,LPF_BW,NoutFilter);

Diff_HG_filt1 = LPFilter(DiffDownHG,LPF_BW,NoutFilter);
Diff_LG_filt1 = LPFilter(DiffDownLG,LPF_BW,NoutFilter);


figure(11);
plot(fftshift(db(fft((Sum_HG_filt1)))));grid on;title('Sum Signal');ylabel('dB');

%%  Down Sampling

NdownSample =   2;
SumHg_Downsample = downsample(Sum_HG_filt1,NdownSample);
SumLg_Downsample = downsample(Sum_LG_filt1,NdownSample); 

DiffHg_Downsample = downsample(Diff_HG_filt1,NdownSample); 
DiffLg_Downsample = downsample(Diff_LG_filt1,NdownSample);  

figure(12);
plot(fftshift(db(fft((SumHg_Downsample)))));grid on;title('Sum Signal');ylabel('dB');

%%  Calculation Amplitude And Phase

NABS = 17;
NPhase = 10;

[sumABS_HG,sumPhiHG]   = CORDIC(SumHg_Downsample,NABS,NPhase);
[sumABS_LG,sumPhiLG]   = CORDIC(SumLg_Downsample,NABS,NPhase);
[diffABS_HG,diffPhiHG] = CORDIC(DiffHg_Downsample,NABS,NPhase);
[diffABS_LG,diffPhiLG] = CORDIC(DiffLg_Downsample,NABS,NPhase);

figure;plot(sumABS_HG)

%% Moving Average Filter
NMAOut = 19;  %US18
sumAmplitudeHG   = MAfilter(sumABS_HG,NMAOut);
sumAmplitudeLG   = MAfilter(sumABS_HG,NMAOut);
diffAmplitudeHG  = MAfilter(sumABS_HG,NMAOut);
diffAmplitudeLG  = MAfilter(sumABS_HG,NMAOut);

figure;plot(db(fftshift(real(fft(diffAmplitudeHG)))))



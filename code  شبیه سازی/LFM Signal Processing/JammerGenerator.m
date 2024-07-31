function [SumJammer,DiffJammer] = JammerGenerator (Fsampling,SimulationTime,Jammer,BeamWidth,DifftoSumPhase);

t              = 0 : 1/Fsampling : SimulationTime-(1/Fsampling);

%%

fIF   = Jammer.IF;
Amp   = Jammer.Amp;
Angle = Jammer.Angle;
delay = Jammer.delay;
T_on  = Jammer.T_on;
Type  = Jammer.Type;

SumSignal  = zeros(1,numel(t));
DiffSignal = zeros(1,numel(t));

%%
for ii = 1:length(fIF)

    seekergain     = Olgo(0,BeamWidth/2,Angle(ii));
    seekerSumGain  = seekergain.sum;
    seekerDiffGain = seekergain.diff;

    if strcmp(Type(ii) , 'Noise')
        SumSignal_vec  = [zeros(1,round(delay(ii)*Fsampling)),Amp(ii)*(randn(1,round(T_on(ii)*Fsampling))+1j*randn(1,round(T_on(ii)*Fsampling)))/sqrt(2)];
        DiffSignal_vec = abs(seekerDiffGain/seekerSumGain)*real(exp(1j*DifftoSumPhase*sign(seekerDiffGain))*SumSignal_vec);
        SumSignal_vec  = real(SumSignal_vec);
    else
        t1 = 0:1/Fsampling:(T_on(ii)-1/Fsampling);
        phi0 = 2*pi*rand;
        SumSignal_vec  = [zeros(1,round(delay(ii)*Fsampling)) , Amp(ii)*sin(2*pi*fIF(ii)*t1+phi0)];
        DiffSignal_vec = [zeros(1,round(delay(ii)*Fsampling)) , abs(seekerDiffGain/seekerSumGain)*Amp(ii)*sin(2*pi*fIF(ii)*t1+DifftoSumPhase*sign(seekerDiffGain)+phi0)];

    end
end


SumSignal_vec(numel(t))  = 0;
DiffSignal_vec(numel(t)) = 0;

SumSignal_vec  =  SumSignal_vec(1:numel(t));
DiffSignal_vec = DiffSignal_vec(1:numel(t));

%%

SumSignal  = SumSignal+SumSignal_vec;
DiffSignal = DiffSignal+DiffSignal_vec;

SumJammer = SumSignal;
DiffJammer = DiffSignal;
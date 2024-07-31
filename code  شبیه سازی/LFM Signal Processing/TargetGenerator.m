function [SumSignal,DiffSignal] = TargetGenerator(Fsampling,SimulationTime,Radar,BeamWidth,DifftoSumPhase)

t              = 0 : 1/Fsampling : SimulationTime-(1/Fsampling);

%% Target
Amp       = Radar.Amp;
fIF       = Radar.IF;
fBW       = Radar.Bw;
PRF       = Radar.Prf;
PRI       = 1./PRF;
PW        = Radar.Pw;
SeekAngel = Radar.SeekAngel  ;
PhaseCode = Radar.Phasecode;
delay     = Radar.delay    ;

SumSignal  = zeros(1,numel(t));
DiffSignal = zeros(1,numel(t));


for ii = 1:length(fIF)   %% Number of Radars

    PulseNumber = ceil(SimulationTime/PRI(ii));
    t1 = 0:1/Fsampling: (PW(ii)-1/Fsampling);
    fchripMat = repmat((fIF(ii)+fBW(ii)*t1/(2*PW(ii))),PulseNumber,1);

    %% Generate Matrix of Pulse
    SeekerGain    = Olgo(0,BeamWidth/2,SeekAngel(ii));
    SeekSumGain   = SeekerGain.sum;
    SeekdiffGain  = SeekerGain.diff;

    T1 = repmat(t1,PulseNumber,1);
    phi0 = 2*pi*repmat(rand(PulseNumber,1),1,numel(t1));
    SumPulse_mat = Amp(ii)*sin(2*pi*fchripMat.*T1+phi0);
    DiffPulse_mat = abs(SeekdiffGain/SeekSumGain)*Amp(ii)*sin(2*pi*fchripMat.*T1+DifftoSumPhase*sign(SeekdiffGain)+phi0);

    if PhaseCode(ii) ~= 0
        PhaseCode_mat = randi([0 1],PulseNumber,ceil(numel(t1)/PhaseCode(ii)));
        PhaseCode_mat(PhaseCode_mat==0) = -1;
        PhaseCode_mat  = kron(PhaseCode_mat,ones(1,PhaseCode(ii)));
        PhaseCode_mat  = PhaseCode_mat(:,1:numel(t1));
        SumPulse_mat = SumPulse_mat.*PhaseCode_mat;
        DiffPulse_mat = DiffPulse_mat.*PhaseCode_mat;
    end
    %% Generate Matrix of PRI's
    SumPRI_mat = SumPulse_mat;
    DiffPRI_mat = DiffPulse_mat;
    SumPRI_mat(:,ceil(PRI(ii)*Fsampling)) = 0;
    DiffPRI_mat(:,ceil(PRI(ii)*Fsampling))= 0;

    %% Signal Vector
    SumSignal_vec  =  [zeros(1,round(delay(ii)*Fsampling)),reshape(SumPRI_mat.',1,[])];
    SumSignal_vec  =  SumSignal_vec(1:numel(t));
    DiffSignal_vec =  [zeros(1,round(delay(ii)*Fsampling)) reshape(DiffPRI_mat.',1,[])];
    DiffSignal_vec =  DiffSignal_vec(1:numel(t));

    %% Add Signals of Radars

    SumSignal  = SumSignal  + SumSignal_vec;
    DiffSignal = DiffSignal + DiffSignal_vec;

end

return
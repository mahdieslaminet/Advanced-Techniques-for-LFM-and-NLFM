function [Amp,Phase] = CORDIC(X,NABS,NPhase)


Amp  = fixpointud(abs(X),0,NABS);
Phase = fixpointud(round(angle(X)*(2^7)),0,NPhase);

end
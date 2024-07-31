function [sigOut] = MAfilter(SigIn,Nup)

Ndown= 2 ;
Nsample = 16;
window = ones(1,Nsample);

SigOut_bf = conv(SigIn,window);
sigOut = fixpointud(SigOut_bf(1:end-(Nsample-1)),Ndown,Nup);
end
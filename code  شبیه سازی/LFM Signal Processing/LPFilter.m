function [SigOut] = LPFilter(SigIn,LPF_BW,Nup)

Ndown = 12;

switch LPF_BW
    case 400
        load('LPF400'); 
end

SifOut_bf = filter(round(LPF400*2^13),1,SigIn);
SigOut    = fixpointud(SifOut_bf,Ndown,Nup);

end
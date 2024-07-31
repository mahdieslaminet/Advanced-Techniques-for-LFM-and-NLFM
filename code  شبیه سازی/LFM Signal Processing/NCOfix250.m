function [ SigOut ] = NCOfix250(SigIn,Nup)

Mixer     = repmat([1 0 1 0],1,length(SigIn)/4)+1i*repmat([0 1 0 -1],1,length(SigIn)/4);
SigOut_bf = Mixer.*SigIn;
SigOut    = fixpointud(SigOut_bf,0,Nup);

end

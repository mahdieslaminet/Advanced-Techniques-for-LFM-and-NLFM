function VoAD = AtoD(VinAD,NB,Vfs)

VoAD = round(VinAD*(2^(NB-1)-1)/Vfs);

end
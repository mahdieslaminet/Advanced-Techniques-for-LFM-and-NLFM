function Vout = fixpointud(Vin,Ndown,Nup)
Vout = round(Vin./2.^Ndown');

Vout(real(Vout)>=(2.^(Nup-1)-1))  = (2.^(Nup-1)-1)+ imag(Vout(real(Vout)>=(2.^(Nup-1)-1)))*1i;

Vout(real(Vout)<=(-(2.^(Nup-1)-1))) = -(2.^(Nup-1)-1) + imag(Vout(real(Vout)<=(-(2.^(Nup-1)-1))))*1i;

Vout(imag(Vout)>=(2.^(Nup-1)-1))     =(2.^(Nup-1)-1)*1i+ real(Vout(imag(Vout)>=(2.^(Nup-1)-1)));

Vout(imag(Vout)<=(-(2.^(Nup-1)-1))) =(-(2.^(Nup-1)-1))*1i + real(Vout(imag(Vout)<=(-(2.^(Nup-1)-1))));
end
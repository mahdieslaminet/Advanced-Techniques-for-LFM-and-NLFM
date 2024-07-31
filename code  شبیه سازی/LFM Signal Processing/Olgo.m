function  [out] = Olgo(Gmax,beamwidth,angle2)

a         = -180:0.01:180;
Sum       = db2mag(Gmax)*abs(sinc(a/beamwidth).^2+0.01);
out.sum   = Sum(18001+floor(angle2*100));
diff      = db2mag(Gmax)*(sinc(((a-beamwidth/2)/beamwidth)).^2 + 0.001) - sinc(((a+beamwidth/2)/beamwidth).^2+0.001);
out.diff  = diff(18001+floor(angle2*100));
return

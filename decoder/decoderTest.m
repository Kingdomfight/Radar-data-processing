clear

fs = 10e3;
tstop = 2;
t = 0:1/fs:tstop;

simConfig = Simulink.SimulationInput('radarModel');
simConfig = simConfig.setModelParameter(StopTime=string(tstop));
simConfig = simConfig.setModelParameter(FixedStep=string(1/fs));
out = sim(simConfig);
theta = getdatasamples(out.yout{1}.Values, 1:numel(t))';
Vr = getdatasamples(out.yout{2}.Values.Vp, 1:numel(t))';
Vc = getdatasamples(out.yout{2}.Values.Vx, 1:numel(t))';
Vs = getdatasamples(out.yout{2}.Values.Vy, 1:numel(t))';

Fpass = 10;
Fstop = 700;
Apass = 1;
Astop = 80;
filterSpecs = fdesign.lowpass(Fpass,Fstop,Apass,Astop,fs);
filterDesign = design(filterSpecs, 'Systemobject', true);
Num = filterDesign.Numerator(:);

Vcr = Vc.*Vr;
filteredCosine = filter(Num,1, Vcr);

Vsr = Vs.*Vr;
filteredSine = filter(Num,1,Vsr);

output = atan2(filteredSine, filteredCosine);
output = mod(output, 2*pi);

[phi, w] = phasedelay(filterDesign, 8192*2, fs);
correction = interp1(w,phi,1);
output = output + correction;

error1 = abs(output - theta);
error2 = abs(output - theta + 2*pi);
error3 = abs(output - theta - 2*pi);
error = min([error1;error2;error3],[],1);

figure
tiledlayout(6,1)

nexttile
plot(t,theta)
title('Theta')

nexttile
plot(t,Vc)
title('Cosine')

nexttile
plot(t,Vs)
title('Sine')

nexttile
hold on
plot(t,filteredCosine)
plot(t,filteredSine)
hold off
title('Extracted Signals')
legend('Cosine', 'Sine')

nexttile
plot(t,output)
title('Output')

nexttile
plot(t,error)
title('Error')

figure
tiledlayout(4,1)
L = size(t,2)-1;
freq = fs/L*(-L/2:L/2);

nexttile
Xcr = fftshift(fft(Vcr));
plot(freq,abs(Xcr))
title('Cosine Carrier Product')
xlabel('Frequency (Hz)')

nexttile
Xsr = fftshift(fft(Vsr));
plot(freq,abs(Xsr))
title('Sine Carrier Product')
xlabel('Frequency (Hz')

nexttile
Xcr_filter = fftshift(fft(filteredCosine));
plot(freq,abs(Xcr_filter))
title('Extracted Cosine')
xlabel('Frequency (Hz)')

nexttile
Xsr_filter = fftshift(fft(filteredSine));
plot(freq,abs(Xsr_filter))
title('Extracted Sine')
xlabel('Frequency (Hz')
clearvars -except Num

E0 = 5;
w = 400*2*pi;
T = 0.5;
fs = 10e3;
t = 0:1/fs:2;
theta = pi*sawtooth(2*pi*t) + pi;

Vr = E0*sin(w*t);
Vc = E0*sin(w*t)*T.*cos(theta);
Vs = E0*sin(w*t)*T.*sin(theta);

Vcr = Vc.*Vr;
filteredCosine = filter(Num,1, Vcr);

Vsr = Vs.*Vr;
filteredSine = filter(Num,1,Vsr);

output = atan2(filteredSine, filteredCosine);
output = mod(output, 2*pi);

correction = 0.0113;
output = output + correction;

error = output - theta;

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
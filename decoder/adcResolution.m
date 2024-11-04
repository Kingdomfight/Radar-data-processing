function bits = adcResolution(maxError, voltageRange)
    t = 0:1e-6:1;
    actualAngle = 2*pi*t;
    vSine = sin(actualAngle);
    vCosine = cos(actualAngle);

    for nBits=1:24
        stepSize = voltageRange/2^nBits;
        vSineRounded = round(vSine/stepSize)*stepSize;
        vCosineRounded = round(vCosine/stepSize)*stepSize;

        computedAngle = unwrap(atan2(vSineRounded,vCosineRounded));
        error = computedAngle - actualAngle;
        if max(abs(error)) < maxError
            break
        end
    end
    bits = nBits;
end
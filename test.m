function FastFourierTransform(Signal, signalName)
    L = length(Signal);
    Fs = 1000;
    
    Signal = Signal - mean(Signal);
    
    
    f = Fs*(0:(L/2))/L;

    Y = fft(Signal);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    figure
    plot(f,P1) 
    title(strcat('Single-Sided Amplitude Spectrum of ', ' ', signalName))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
    figure
    loglog(f,P1)
    title(strcat('Loglog Single-Sided Amplitude Spectrum of ', ' ', signalName))
    xlabel('f (Hz)')
    ylabel('|P1(f)|') 
end
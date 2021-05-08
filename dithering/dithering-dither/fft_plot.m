function [f, P1] = fft_plot(x, L, Fs)
y = fft(x);
P2 = abs(y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1);
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel("Frequency [Hz]");
ylabel("Amplitude");
end


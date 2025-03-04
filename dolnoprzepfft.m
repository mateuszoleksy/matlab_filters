close all; clear; clc;
[y,fs] = audioread("testowy.wav");
samples = y(2000:3000);
t = (0:length(samples)-1) / fs;

prod = 0;
N = 101;
fg = 1000;
L = length(samples);

iterator = -(N)/2+1;
%obliczenie transformaty od samples, probek wejsciowych sygnalu
widmo = fft(samples);
%obliczanie wspolczynikow dla filtru dolnoprzepustowego, z transformaty
%filtru, wraz z implementacja okna
window = hamming(N-1);

for k=1:N-1
     if (iterator ~= 0)
     h(k) = sin(2*pi*iterator*fg/fs)/(iterator*pi)*window(k);
    else
      h(k) = 2*fg/fs*window(k);
    end
     iterator = iterator+1;
end

%wykresy odpowiadające za odpowiedz "impulsową" filtru FIR: wlasnego
%algorytmu oraz FIR algorytm matlab
figure("Name", "Odpowiedź impulsowa", "NumberTitle", "off");
subplot(2,1,1);
stem(h,'r-');
title("Własny algorytm.");
title("Odpowiedz impulsowa filtru DP.");

subplot(2,1,2);
b =  fir1(N-2, fg / (fs/2), 'low');
stem(b);
title("Algorytm FIR (z oknem).");

%w dwóch osobnych figurach mamy wykres modulu transmitancji oraz fazy dla
%filtru algorytmu matlab oraz dla filtru własnego
figure("Name", "Algorytm FIR matlab", "NumberTitle", "off");
freqz(b);
figure("Name", "Algorytm FIR własny algorytm", "NumberTitle","off");
freqz(h);

figure("Name", "Porównanie sygnałów", "NumberTitle","off");
plot(t,samples, 'b-');
title("Sygnał w dziedzienie czasu.");
hold on;


%stosujemy transmitancje filtru dla kazdej probki
original = widmo;
for n=N+1:1:length(widmo)
    for i=1:1:N-1
         prod = prod + original(n-i-1)*h(i);
    end
    Y2(n) = prod;
    prod = 0;
end

%obliczamy transfomate odwrotna dla przeksztalconego widma
plot(t,ifft(Y2*N),'r-');
legend('Pierwotny', 'Po filtracji');

filtr = filter(impz(b),1,samples);
figure;
plot(t,samples, 'b-');
hold on;
plot(t,filtr,'r-');
legend('Pierwotny', 'Po filtracji');

%zapisz do pliku wynik wykonania
audiowrite("wynik.wav",real(ifft(Y2)),fs);


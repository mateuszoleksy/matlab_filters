close all; clear; clc;
%generacja sygnału zaszumionego i definicja paramterów
fs = 1000;                        
T = 1/fs;               
L = 1500;         
t = (0:L-1)*T;       
S = 0.8 + 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
samples = S;

prod = 0;
N = 101;
fd = 10;

iterator = -(N-1)/2;
indeks = 0;

%obliczenie transformaty od samples, próbek wejściowych sygnału
widmo = fft(samples);
%obliczanie współczynników dla filtru górnoprzepustowego, z transformaty
%filtru z zastosowaniem okna
window = hamming(N);

for k=1:N-1
    if (iterator ~= 0)
     h(k) = -sin(2*pi*iterator*fd/fs)/(iterator*pi)*window(k);
    else
      h(k) = -2*fd/fs*window(k);
    end
     iterator = iterator+1;
end
h((N-1)/2+1)=h((N-1)/2+1)+1;


%wykres odpowiadający za odpowiedz "impulsową" filtru FIR: własnego
%algorytmu
figure("Name", "Odpowiedź impulsowa", "NumberTitle", "off");
stem(h,'r-');
title("Odpowiedz impulsowa filtru GP, algorytm własny.");


%wykres modułu transmitancji oraz fazy
figure("Name", "Algorytm FIR własny algorytm", "NumberTitle","off");
freqz(h);

figure("Name", "Porównanie sygnałów", "NumberTitle","off");
plot(t,samples, 'b-');
title("Sygnał w dziedzienie czasu.");
hold on;

%stosujemy transmitancję filtru dla każdej próbki
original = samples;
for n=1:1:length(samples)
    for i=1:1:N-1
        if (n-i-1<1)
         prod = prod + conv(0, h(i));
        else
           prod = prod + conv(original(n-i-1), h(i)); 
        end
    end
    Y2(n) = prod;
    prod = 0;
end

%obliczamy transfomate odwrotną dla przekształconego widma
plot(t,Y2,'r-');
xlabel('Częstotliwość [Hz]')
ylabel('Amplituda')
legend('Pierwotny', 'Po filtracji');

%wypisujemy widmo sygnalu przekształconego
figure("Name", "Widmo sygnału", "NumberTitle","off");
L = length(widmo);
P2 = abs(widmo/L.^2);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs/L*(0:(L/2));
plot(f,P1,'g-','LineWidth',1.5);
hold on;
L = length(fft(Y2));
P2 = abs(fft(Y2)/L.^2);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs/L*(0:(L/2));
plot(f,P1,'r-','LineWidth',2)
title("Widmo sygnału pierwotnego");
xlabel('Częstotliwość [Hz]')
ylabel('Amplituda')
legend("Sygnał pierwotny","Sygnał przefiltrowany");
title("Widmo sygnału.");



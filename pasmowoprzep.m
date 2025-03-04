close all; clear; clc;
%wczytywanie sygnału dźwiękowego z pliku
[y,fs] = audioread("testowy.wav");
%wybranie fragmentu utworu
samples = y(2000:5000);
%generacja osi czasu
t = (0:length(samples)-1) / fs;

%definicja parametrów filtru
prod = 0;
N = 101;
fd = 1000;
fg = 10000;

iterator = -(N-1)/2;
indeks = 0;
%obliczenie transformaty od samples, próbek wejściowych sygnału
widmo = fft(samples);
%obliczanie współczynników dla filtru pasmowo-przepustowego, z transformaty
%filtru z zastowaniem okna
window = hamming(N);

iterator = -(N-1)/2;
for k=1:N-1
     if (iterator ~= 0)
     g(k) = sin(2*pi*iterator*fg/fs)/(iterator*pi)*window(k);
    else
      g(k) = 2*fg/fs*window(k);
    end
     iterator = iterator+1;
end

iterator = -(N-1)/2;
for k=1:N-1
    if (iterator ~= 0)
     h(k) = -sin(2*pi*iterator*fd/fs)/(iterator*pi)*window(k);
    else
      h(k) = -2*fd/fs*window(k);
    end
     iterator = iterator+1;
end
h((N-1)/2+1)=h((N-1)/2+1)+1;

%splot
wynik = conv(h,g);

%wykresy odpowiadające za odpowiedz "impulsową" filtru FIR: wlasnego
%algorytmu DOLNO oraz GÓRNO przepustowego
figure('Name', 'Porównanie impulsów filtrów', 'NumberTitle','off');
subplot(2,1,1);
stem(h,'r-');
title("Odpowiedz impulsowa filtru GP.");
subplot(2,1,2);
stem(g);
title("Odpowiedz impulsowa filtru DP.");

% odpowiedz impulsowa dla filtru złożonego z dwóch filtrów
figure('Name', 'Odpowiedź impulsowa filtru.', 'NumberTitle', 'off');
stem(wynik,'r-');
title("Odpowiedz impulsowa filtru pasmowo-przepustowego.");

%wykres modułu transmitancji oraz fazy dla
%filtru
figure;
freqz(wynik);

figure("Name", "Porównanie sygnałów", "NumberTitle","off");
plot(t,samples, 'b-');
title("Sygnał w dziedzienie czasu.");
hold on;

%stosujemy transmitancję filtru dla kazdej próbki
original = samples;
for n=1:1:length(samples)
    for i=1:1:N-1
         if (n-i-1<1)
         prod = prod + conv(0, wynik(i));
        else
           prod = prod + conv(original(n-i-1), wynik(i)); 
        end
    end
    Y2(n) = prod;
    prod = 0;
end


%obliczamy transformatę odwrotną dla przekształconego widma
plot(t,Y2,'r-');
ylabel('Amplituda sygnału')
xlabel('Czas [s]')
legend('Pierwotny', 'Po filtracji');

%wypisujemy widmo sygnału przekształconego
%Widmo sygnału
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

%zapisujemy do pliku wynik wykonania
audiowrite("wynik.wav",samples,fs);




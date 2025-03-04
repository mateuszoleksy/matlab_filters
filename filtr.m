close all; clear; clc;
[y,fs] = audioread("testowy.wav");

% Extract the first 5000 samples
samples = y(1:20000);
% Create the corresponding time axis
t = (0:length(samples)-1) / fs;
% Plot the signal;
figure;
plot(t, samples);
xlabel('Time (s)');
ylabel('Amplitude');

prod = 0;
N=4;

figure;
x = linspace(-2*pi+0.01,2*pi-0.01,N);
h = sin(x)./x;
plot(x,h,'r-');

figure;
widmo = fft(samples);
plot(abs(widmo));

figure;
plot(t,samples, 'b-');
hold on;

for n=(N+1):1:length(widmo)
    for i=0:1:N-1
        prod = prod + widmo(n-i) * 1/N;
    end
    widmo(n) = prod;
    prod = 0;
end

plot(t, ifft(widmo), 'r-');
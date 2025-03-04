x = linspace(0,2*pi,100);
y = sin(x);
prod = 0;

for i=1:1:N-1
    y(i) = y(i) + x(i) * 1/N;
end

plot(x,y,'r-')
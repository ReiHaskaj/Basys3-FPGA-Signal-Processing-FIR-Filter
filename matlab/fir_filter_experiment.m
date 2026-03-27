%%FIR Filter Experiment

%%Generate test signal.
%%Design FIR filter.
%%Apply filtering.
%%Visualize result.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Parameters
Fs = 1000;
t = 0:1/Fs:1;

%%Signal generation
A = 3 * sin(2 * pi * 5 * t);
B = 2 * sin(2 * pi * 50 * t);
S = A + B;

%%FIR filter design
Fc = 10;
N = 16;
h = fir1(N, Fc/(Fs/2));

%%Filtering operation
y = filter(h, 1, S);

%%Plots
figure

subplot(2,1,1)
plot(t, S)
title('Input Signal')

subplot(2,1,2)
plot(t, y)
title('Filtered Output')

%%Coefficients
figure
stem(h)
title('FIR Coefficients')

%%Check ranges
sum(h);
max(h);
min(h);
max(S);
min(S);
max(y);
min(y);
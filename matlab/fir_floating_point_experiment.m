%%Floating point experiment

%%Use fir_filter_experiment.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
y_float = filter(h, 1, S);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Fixed-point format setting Q4.8 and Q2.10
Fx = 8;
Fh = 10;

%%Quantize input and coefficients to integers
S_int = round(S * 2^Fx);
h_int = round(h * 2^Fh);

%%Reconstruct quantized values
S_q = S_int / 2^Fx;
h_q = h_int / 2^Fh;

%%Quantization errors
err_S = S - S_q;
err_h = h - h_q;

fprintf('Max input quantization error : %g\n', max(abs(err_S)));
fprintf('Max coefficient quantization error : %g\n', max(abs(err_h)));

%%Fixed_point FIR using integer arithmetic
L = length(S_int);
TAPS = length(h_int);

y_int = zeros(1, L);

for n = 1:L
    acc = 0;
    for k = 1:TAPS
        if (n-k+1) > 0
            acc = acc + S_int(n-k+1) * h_int(k);
        end
    end
    y_int(n) = acc;
end

%%Reconstruct the fixed_point output
Fy = Fx + Fh;
y_fixed = y_int / 2^Fy;

%%Output error 
err_y = y_float - y_fixed;

fprintf('Max output error : %g\n', max(abs(err_y)));
fprintf('Mean output error : %g\n', mean(abs(err_y)));

%%Plots
figure
plot(t, y_float, 'DisplayName', 'Floating-point')
hold on
plot(t, y_fixed, '--', 'DisplayName', 'Fixed-point')
legend
title('Floating-point vs Fixed-point FIR Output')
xlabel('Time (s)')
ylabel('Amplitude')
grid on
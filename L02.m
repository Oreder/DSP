clear, clc, close all

A = 2;
Sigma = 5;
T0 = 5;
time = 100;

% Input
N = input('Input number chosen points: ');    % 51
dX = %input('Step: ');                        % 0.1
X_max = dX * (N - 1) / 2;  % +X0 - (-X0)
X_min = -X_max;
X = X_min: dX: X_max;
Y1 = gauss(A, X, Sigma);
Y2 = deltaRec(X, T0);

% Fast Fourier Transform
Z1 = fft(Y1);
Z2 = fft(Y2);

% Discrete Fourier Transform
V1 = zeros(1, N);
V2 = zeros(1, N);
for n = 0:(N-1)
    for k = 0:(N-1)
      V1(n+1) = V1(n+1) + Y1(k+1) * exp(1i * -2 * pi * n * k / N);
      V2(n+1) = V2(n+1) + Y2(k+1) * exp(1i * -2 * pi * n * k / N);
    end;
end;

% Inverse result
N1 = fix(N/2);

for k = 1:fix(N1/2)
  [V1(k), V1(N1-k+1)] = deal(V1(N1-k+1), V1(k));
  [Z1(k), Z1(N1-k+1)] = deal(Z1(N1-k+1), Z1(k));
  [V1(N-k+1), V1(N1+k)] = deal(V1(N1+k), V1(N-k+1));
  [Z1(N-k+1), Z1(N1+k)] = deal(Z1(N1+k), Z1(N-k+1));
  
  [V2(k), V2(N1-k+1)] = deal(V2(N1-k+1), V2(k));
  [Z2(k), Z2(N1-k+1)] = deal(Z2(N1-k+1), Z2(k));
  [V2(N-k+1), V2(N1+k)] = deal(V2(N1+k), V2(N-k+1));
  [Z2(N-k+1), Z2(N1+k)] = deal(Z2(N1+k), Z2(N-k+1));
end

f = (0 : N-1) * time / N;
 
figure;
title('Gauss-signal Plots');
plot(f, abs(V1), '-.r');
hold on;
plot(f, abs(Z1), 'd');
hold off;
legend('DFT', 'FFT');

figure;
title('Rectangle-signal Plots');
plot(f, abs(V2), '-.r');
hold on;
plot(f, abs(Z2), 'd');
hold off;
legend('DFT', 'FFT');
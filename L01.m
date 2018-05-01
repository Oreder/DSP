clear, clc, close all

A = 2;
Sigma = 5;
T0 = 5;

% Input
nX = input('Input number chosen points: ');   % 151
dX = input('Step: ');                         % 0.1
X_max = dX * (nX - 1) / 2;            % +X0 - (-X0)
X_min = -X_max;
X = X_min: dX: X_max;
Y1 = gauss(A, X, Sigma);
Y2 = deltaRec(X, T0);

t_min = -10;
N = 101;
dT = 20 / N;
t = zeros(N);
Z1 = zeros(N);
Z2 = zeros(N);

for i = 1:N
  t(i) = t_min + (i - 1) * dT;
  for jX = 1:nX
    if t(i) == X(jX)
      Z1(i) = Z1(i) + Y1(jX);
      Z2(i) = Z2(i) + Y2(jX);
    else
      Z1(i) = Z1(i) + Y1(jX) * sinc(pi * (t(i) - X(jX)) / dX);
      Z2(i) = Z2(i) + Y2(jX) * sinc(pi * (t(i) - X(jX)) / dX);
    end
  end
  
end

figure
title('Gauss-signal Plots');
%Y1 = gauss(A, t, Sigma);
grid on;
plot(X, Y1, 'b');
hold on;
plot(t, Z1, 'r');
hold off;

X = X_min:0.05:X_max;
Y2 = deltaRec(X, T0);
figure
title('Rectangle-signal Plots');
grid on;
plot(X, Y2, 'b');
hold on;
plot(t, Z2, 'r');
hold off;
clear, clc, close all

A = 2;
Sigma = 5;
T0 = 5;
time = 100;

% Input
N = 51;%input('Input number chosen points: ');
dX = 0.5;%input('Step: ');
X_max = dX * (N - 1) / 2;  % +X0 - (-X0)
X_min = -X_max;
X = X_min: dX: X_max;
Y1 = gauss(A, X, Sigma);
Y2 = deltaRec(X, T0);

Z1 = conv(Y1, Y1, 'same');
Z2 = conv(Y1, Y2, 'same');
Z3 = conv(Y2, Y2, 'same');

figure
plot(X, Z1);

figure
plot(X, Z2);

figure
plot(X, Z3);
function Lab07
  N = 151;
  X0 = 10;
  dX = 2. * X0 / (N - 1);      % T = 2.X0
  X = -X0 : dX : +X0;
  
  u1 = exp(-X.^2 /2);   % first signal
  u2 = exp(-X.^2 / 4);  % second signal
  d1 = unifrnd(0.05, 0.1) * max(u1);  % delta
  e2 = unifrnd(0.05, 0.1) * max(u2);  % epsilon
  
  % find root a0 of p(a) = 0;
  func = @(x) p(x, u1, d1, u2, e2, dX, N);
  a0 = fzero(func, 1.);
  
  % Calculate H
  H = zeros(length(X), 1);
  for k = 1:N
    sum = 0.;
    for m = 0:N-1
      U2 = fft(u2(m + 1));
      U1 = fft(u1(m + 1));
      dZ = 1 + (2. * pi * m * dX / N).^2;
      sum = sum + U2 * U1 * exp(1j * 2. * pi * k * m / N) / ...
            ((abs(U2) * dX).^2 + a0 * dZ);
    end
    H(k) = sum * dX / N;
  end
  
  disp(a0);
  figure, grid;
  plot(X, abs(ifft(H)));
end

function result = p(alpha, u1, d1, u2, e2, dX, N)
  U1 = abs(fft(u1)).^2;
  U2 = abs(fft(u2)).^2;
  dX2 = dX.^2;
  a2 = alpha * alpha;
  
  beta = 0.;
  gamma = 0.;
  for m = 0:N-1
    freq = 1 + (2 * pi * m * dX / N).^2;
    beta = beta + a2 * freq * U1(m+1) / ...
          (U2(m+1) * dX2 + alpha * freq).^2;
        
    gamma = gamma + U2(m+1) * dX2 * freq * U1(m+1) / ...
           (U2(m+1) * dX2 + alpha * freq).^2;
  end
  
  dz = dX / N;
  result = beta * dz - (e2 + d1 * sqrt(gamma)).^2;
end
function Y = gauss(a, X, Sigma)
  n = length(X);
  Y = X;
  for i = 1:n
    Y(i) = a * exp(- X(i) * X(i) / Sigma / Sigma);
  end
end

% function y = gauss(a, x, t)
%   y = a * exp(-x * x / t / t);
% end
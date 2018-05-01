function Y = deltaRec(X, T0)
  n = length(X);
  Y = zeros(1, n);
  for i = 1:n
    if abs(X(i)) < T0
      Y(i) = 1;
    end
  end
end
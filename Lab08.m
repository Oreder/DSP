function Lab08
  clear, clc, close all
  
  Sigma = 2.;
  f = 10;
  
  n = 6;
  Epsilon = 1E-3;
  
  Range = getRange(f);
  u0 = GetGaussSignal(Sigma, f);

  noise_height = 0.25;
	noise_count = 6;
	
  % Generate noises
	impulse_noise = getImpulseNoise(GetSize(f), noise_height, noise_count);
  
  % Combine beginning signal with noises
	u1 = addNoise(u0, impulse_noise);
  
  % Applying smoothing
  u2 = MEANFilter(u1, n, Epsilon);
  u3 = medfilt1(u1, n);

  subplot(2, 2, 1);
  plot(Range, u1), grid, title('Source signal');

  subplot(2, 2, 2);
  plot(Range,u2), grid, title('Smoothing by MEAN');

  subplot(2, 2, 4);
  plot(Range,u3), grid, title('Smoothing by MED');
end
    
function delta = DeltaFreq(f)
  delta = 1.0 / (2*f);
end

function size = GetSize(f)
	size = (4*f) / DeltaFreq(f) + 1;
end

function array = getRange(f)
	dX = DeltaFreq(f);
	X0 = -2.0*f;
	n = (2.*f) ./ dX;
	signal = zeros(2*n + 1, 1);

	for i = 1 : (2*n + 1)
		signal(i) = X0 + (i-1) .* dX;
	end;
  
	array = signal;
end

function array = GetGaussSignal(sigma, f)
	dt = DeltaFreq(f);
	n = (2 * f) / dt;
	signal = zeros(2*n + 1, 1);

	t = -2.0 * f;
	for i = 1 : 2*n+1
		signal(i) = exp(-(t/sigma)^2);
		t = t + dt;
	end;

  array = signal;    
end

function array = getImpulseNoise(size, koff, kol)
  signal = rand(kol, 2);
  
  for i = 1 : kol
    signal(i,1) = signal(i,1) * koff;
    signal(i,2) = floor(signal(i,2) * size);
  end
  
  array = signal;
end

function array = addNoise(signal, noise)
  n = length(noise);
  result = signal;

  for i = 1:n
    index = noise(i,2);
    result(index) = result(index) + noise(i,1);
  end

  array = result;
end

function array = MEANFilter(signal, n, Epsilon)
  R = length(signal);
  array = zeros(R,1);

  id_start = n + 1;
  id_end = R - n;

  for i = id_start:id_end
    smth = mean(signal(i-n : i+n));
    for j = (i-n):(i+n)
      if (abs(signal(j) - smth) < Epsilon)
        array(j) = signal(j);
      else
        array(j) = smth;
      end        
    end
  end
end
function Lab06
	sigma = 2.;
	f = 10;
	range = getRange(f);
	u0 = GetGaussSignal(sigma, f);

	noise_height = 0.8;
	noise_count = 6;
	
  % Generate noises
	impulse_noise = getImpulseNoise(GetSize(f), noise_height, noise_count);
  gauss_noise = getGaussNoise(noise_height, GetSize(f));
	
  % Combine beginning signal with noises
	u1 = addNoise(u0, impulse_noise);
  u2 = addNoise(u0, gauss_noise);
	
	w2 = WienerFilter(u2);
	w1 = WienerFilter(u1);

  figure
	plot(range, u1,'b'), grid;
	hold on;
	plot(range, w1,'r'), grid, title(('Uniform noise by Wiener filter'));
  
	figure
	plot(range, u2,'b'), grid;
	hold on;
	plot(range, w2,'r'), grid, title(('Gauss noise by Wiener filter'));
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

for i=1:kol
    signal(i,1) = signal(i,1)*koff;
    signal(i,2) = floor(signal(i,2)*size);
end

array = signal;
end

function array = getGaussNoise(height, n)
  signal = unifrnd(5,6,n,2);
    
  for i = 1:n
    if (mod(i,10) == 0)
        signal(i,1) = rem(signal(i,1) * height, height);
    else
        signal(i,1) = 0;
    end
    signal(i,2) = i;
  end

  array = signal;
end

function array = addNoise(signal, noise)
  n = size(noise);
  n = n(1);
  
  result = signal;

  for i = 1:n
    index = noise(i,2);
    result(index) = result(index) + noise(i,1);
  end

  array = result;
end

function array = GetnoiseFromSignal(Signal)
  n = size(Signal);
  n = n(1);
  spectre = zeros(n,1);

  SideCount = 5;
  Eps = 0.1;

  for i = SideCount+1 : n-SideCount
    sideValue = 0;
    for j=-SideCount:SideCount
       sideValue = sideValue + Signal(i+j);        
    end
    sideValue = sideValue/(2*SideCount+1);
    spectre(i) = sideValue;
    
    if (abs(Signal(i)-sideValue) > Eps*Signal(i))
        spectre(i) = Signal(i)-sideValue;
    else
        spectre(i) = 0;
    end
  end

  array = spectre;
end

function array = GetSignalPower(Signal)
  FFT_Signal = fft(Signal);
  array = FFT_Signal.*conj(FFT_Signal);
end

function array = WienerFilter(SignalWithnoise)
  noise = GetnoiseFromSignal(SignalWithnoise);
  PureSignal = SignalWithnoise - noise;

  NFFT = size(SignalWithnoise);
  NFFT = NFFT(1);

  PureSignalPower = GetSignalPower(PureSignal);
  noisePower = GetSignalPower(noise);

  H = zeros(NFFT,1);
  for i=1:NFFT
    H(i)=PureSignalPower(i)/(PureSignalPower(i)+noisePower(i)); %???????????¤ ??????¤
  end

  SignalSpectre = fft(SignalWithnoise);
  array = ifft(SignalSpectre.*H);
end
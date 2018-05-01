function Lab04
    t = -10 : 0.01 : +10;
    n = length(t);
    dt = t(2) - t(1);
    f = [-(n - 1)/2 : +(n - 1)/2] / (n * dt);
    
    u0 = 1 * exp(-t.^2 / 2);
    
    ua = u0 + uniformError(t);
    ub = u0 + normalError(t);

    subplot(3, 2, 1);
    plot(t, ua);
    title('Gauss signal with Uniform noise');
    
    subplot(3, 2, 2);
    plot(t, ub);
    title('Gauss signal with Normal noise');
    
    subplot(3, 2, 3);
    plot(t, despectrize(spectrize(ua) .* butterworthFilter(f, 2, 1)));
    %plot(t, ua, t, despectrize(spectrize(ua) .* butterworthFilter(f, 2, 1)));
    title('Uniform noise by Butterword filter');

    subplot(3, 2, 4);
    plot(t, despectrize(spectrize(ub) .* butterworthFilter(f, 2, 1)));
    %plot(t, ub, t, despectrize(spectrize(ub) .* butterworthFilter(f, 2, 1)));
    title('Normal noise by Butterword filter');
    
    subplot(3, 2, 5);
    plot(t, despectrize(spectrize(ua) .* gaussFilter(f, 2)));
    %plot(t, ua, t, despectrize(spectrize(ua) .* gaussFilter(f, 2)));
    title('Uniform noise by Gauss filter');

    subplot(3, 2, 6);
    plot(t, despectrize(spectrize(ub) .* gaussFilter(f, 2)));
    %plot(t, ub, t, despectrize(spectrize(ub) .* gaussFilter(f, 2)));
    title('Normal noise by Gauss filter');
end
    
function s = spectrize(x)
    s = fftshift(fft(x));
end

function x = despectrize(s)
    x = ifft(ifftshift(s));
end

function e = uniformError(t)
    n = length(t);
    e = zeros(1, n);
    c = round(unifrnd(5, 7));
    iNoise = round(unifrnd(1, n, 1, c));
    e(iNoise) = unifrnd(-1, +1, 1, c) * 0.24;
end

function e = normalError(t)
    e = normrnd(0, 0.24, 1, length(t));
end    

function h = butterworthFilter(f, d, n)
    h = 1 ./ (1 + (f ./ d) .^ (2 * n));
end

function h = gaussFilter(f, s)
    h = exp(-(f ./ (2 .* s)) .^ 2);
end
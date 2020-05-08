function y = sigrms(w)
mask = isfinite(w);
w = w(mask) - mean(w(mask));
y = sqrt((1/numel(w))*sum(w.^2));
end
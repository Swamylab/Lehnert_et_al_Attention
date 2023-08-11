function [z, y] = gaussSmoothD3(x,sig)% z = gaussSmoothD3(x,sig)    % gaussin filter    if sig == 0        y = [0 1 0];    else        w = ceil(sig * 3);        if w < 1            w = 1;        end        t = -w : w;        y = normpdf(t,0,sig);    end    % filter along dim 3    nPad = floor(length(y)/2);    z = filter(y,1,cat(3, x, zeros(size(x,1), size(x,2), nPad)), [], 3);    z = z(:, :, nPad+1:end);end
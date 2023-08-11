function h = gaborFilt(orientation, wavelength, sigmaX, sigmaY, sigmaYScale, width)

    % From matlab's gabor.m

    if isempty(sigmaX)
        % From relationship in "Nonlinear Operator in Oriented Texture", Kruizinga,
        % Petkov, 1999.
        BW = 1;
        sigmaX = wavelength/pi*sqrt(log(2)/2)*(2^BW+1)/(2^BW-1);
    end
    if isempty(sigmaY)
        sigmaY = sigmaX * sigmaYScale; % sigmaYScale = 2 in matlab's gabor.m   
    end

    % assume phase is 0
    halfWidth = ceil(width/2);
    [X,Y] = meshgrid(-halfWidth:halfWidth, -halfWidth:halfWidth);

    Xprime = X .* cosd(orientation) - Y .* sind(orientation);
    Yprime = X .* sind(orientation) + Y .* cosd(orientation);

    hGaussian = exp( -1/2 * ( Xprime.^2 ./ sigmaX^2 + Yprime.^2 ./ sigmaY^2));
    hGaborEven = hGaussian.*cos(2*pi.*Xprime ./ wavelength);
    hGaborOdd  = hGaussian.*sin(2*pi.*Xprime ./ wavelength);

    h = complex(hGaborEven,hGaborOdd);
end
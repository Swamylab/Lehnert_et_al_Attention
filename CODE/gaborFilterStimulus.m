function S = gaborFilterStimulus(s, g)
    if isreal(g)
        S = convn(double(s),  g, 'same');
    else
        S = abs(convn(double(s),  g, 'same'));
    end
end
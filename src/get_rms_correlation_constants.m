function [ rms ] = get_rms_correlation_constants( Cv )
% Find RMS of values present in Cv
    
    numSrc = size(Cv, 2);
    rms = 0;
    for i = 1: numSrc
        rms = rms + Cv(1, i) * Cv(1, i);
    end

end


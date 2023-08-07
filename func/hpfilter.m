function H = hpfilter(type, M, N, D0, n)
    %HPFILTER Computes frequency domain highpass filters.
    
    if nargin == 4
       n = 1; % Default value of n.
    end
    
    % Generate highpass filter.
    Hlp = lpfilter(type, M, N, D0, n);
    H = 1 - Hlp;
    
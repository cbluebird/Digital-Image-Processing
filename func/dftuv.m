function [ U,V ] = dftuv( M, N )
    %DFTUV 实现频域滤波器的网格函数

    % Set up range of variables.
    u = single(0:(M - 1));
    v = single(0:(N - 1));

    % Compute the indices for use in meshgrid.
    idx = find(u > M/2); %找大于M/2的数据
    u(idx) = u(idx) - M; %将大于M/2的数据减去M
    idy = find(v > N/2);
    v(idy) = v(idy) - N;

    % Compute the meshgrid arrays.
    [V, U] = meshgrid(v, u);      
    
    end
function [x_est] = OMPMJ(y, A, k)

% read the problm dimensions
[~, N] = size(A);

% Initialization
x_est = zeros(N, 1);
supp = [];

for iter = 1:k

    % compute the residual
    residual = y - A*x_est;

    % find the index of column of A which is maximally correlated to the
    % residual
    correlation_vec = abs(A'*residual);
    [~, max_idx] = max(correlation_vec);

    % Update the support set estimate
    supp = union(supp, max_idx);

    % Update the estimate of x
    A_supp = A(:, supp);
    x_est = zeros(N,1);
    x_est(supp) = inv(A_supp'*A_supp)*A_supp'*y;

end


end
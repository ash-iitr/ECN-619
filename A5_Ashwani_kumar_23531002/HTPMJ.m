function [x_est] = HTPMJ(y, A, k)
% HTP: Hard Thresholding Pursuit Algorithm
%   y: Measurement vector
%   A: Sensing matrix
%   k: Sparsity level

% Read the problem dimensions
[~, N] = size(A);

% Initialization
x_est = zeros(N, 1);
residual = y;
supp = [];

for iter = 1:k

    % Compute the inner product of the residual with the sensing matrix
    projections = abs(A' * residual);

    % Identify the indices of the largest components
    [~, indices] = sort(projections, 'descend');
    supp = indices(1:k);

    % Construct the support set matrix
    A_supp = A(:, supp);

    % Solve the least squares problem min ||y - A_supp * x||^2_2 for x
    x_temp = zeros(N, 1);
    x_temp(supp) = A_supp \ y;

    % Update the estimate of x
    x_est = zeros(N, 1);
    x_est(supp) = x_temp(supp);

    % Update the residual
    residual = y - A * x_est;

end

end

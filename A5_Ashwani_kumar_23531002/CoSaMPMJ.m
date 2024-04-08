function [x_est] = CoSaMPMJ(y, A, k)

% read the problem dimensions
[~, N] = size(A);

% Initialization
x_est = zeros(N, 1);
residual = y;
supp = [];

for iter = 1:k

    % Step 1: Compute the inner product of the residual with the sensing matrix
    projections = abs(A' * residual);

    % Step 2: Identify 2k largest components of the projection vector
    [~, indices] = sort(projections, 'descend');
    omega = indices(1:2*k);

    % Step 3: Identify 2k largest components of x_est
    [~, indices] = sort(abs(x_est), 'descend');
    omega_tilde = indices(1:2*k);

    % Step 4: Form the set Omega by combining the indices from steps 2 and 3
    Omega = union(omega, omega_tilde);

    % Step 5: Construct a submatrix of A using the columns corresponding to Omega
    A_Omega = A(:, Omega);

    % Step 6: Solve the least squares problem min ||y - A_Omega * x||^2_2 for x
    x_est = zeros(N, 1);
    x_est(Omega) = pinv(A_Omega) * y;

    % Step 7: Prune the support set
    [~, indices] = sort(abs(x_est), 'descend');
    supp = indices(1:k);

    % Step 8: Update the residual
    residual = y - A * x_est;

end

end

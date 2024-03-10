function [x_est] = lasso(y,A,tau)
[~,cols] = size(A);
N = cols;

cvx_begin
    variable z(N);
    minimize(power(2,norm(y-A*z,2)));
    subject to
        norm(z,1) <= tau;
cvx_end

for index = 1:length(z)
    if abs(z(index)) < 1e-6
        z(index) = 0;
    end
end

x_est = z;
end
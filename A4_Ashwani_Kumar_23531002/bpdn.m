function [x_est] = bpdn(y,A,lambda)
[~,cols] = size(A);
N = cols;

cvx_begin
    variable z(N);
    minimize(power(2,norm(y-A*z,2)) + lambda*norm(z,1));
cvx_end

for index = 1:length(z)
    if abs(z(index)) < 1e-6
        z(index) = 0;
    end
end

x_est = z;
end
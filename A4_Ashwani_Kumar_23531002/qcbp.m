function [x_est] = qcbp(y,A,eta)
[~,cols] = size(A);
N = cols;

cvx_begin
    variable z(N);
    minimize(norm(z,1));
    subject to
        power(2,norm(y-A*z,2)) <= eta;
cvx_end

for index = 1:length(z)
    if abs(z(index)) < 1e-6
        z(index) = 0;
    end
end

x_est = z;
end
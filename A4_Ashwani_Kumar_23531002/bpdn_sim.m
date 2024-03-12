clc;
close all;
clear;

N = 100;
k = 20;  % Cardinality of supp(x)
m = 200; % Overdetermined system as m>N
noise_variance = 0.01; % given S.D. of noise was 0.1
lambda = 4; % Tweak this value to get good reconstruction of x

x = zeros(N,1);
support = randperm(N,k);
x(support) = randn(k,1); % random k-sparse vector x generated

%plot(1:N,x);


e = sqrt(noise_variance) * randn(m,1); % noise generated
A = sqrt(1/m)*randn(m,N); % Measurement matrix generated

y = A*x + e;

x_est = bpdn(y,A,lambda);

figure;
plot(1:N, x, 'b', 'linewidth', 2); hold on;
plot(1:N, x_est, 'r');
legend('ground truth','reconstructed vector');
xlabel('n');
ylabel('x(n)');
title('BPDN simulation');

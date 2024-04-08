clc;
close all;
clear;

N = 400;
k = 10;  % Cardinality of supp(x)
m = 100; % Overdetermined system as m>N
noise_variance = 0.01; % given S.D. of noise was 0.1
% alpha = 1.45;
% eta = alpha * m * noise_variance;

x = zeros(N,1);
support = randperm(N,k);
x(support) = randn(k,1); % random k-sparse vector x generated

%plot(1:N,x);


e = sqrt(noise_variance) * randn(m,1); % noise generated
A = (1/sqrt(m))*randn(m,N); % Measurement matrix generated

y = A*x + e;


x_est_OMP = OMPMJ(y,A,k);
x_est_CoSaMP = CoSaMPMJ(y,A,k);
x_est_HTP = HTPMJ(y,A,k);

figure(1);
subplot(211);
plot(1:N, x, 'b', 'linewidth', 2);
grid on;

subplot(212);
plot(1:N, x, 'b', 'linewidth', 2); hold on;
plot(1:N, x_est_OMP, 'g');
legend('ground truth','OMP output');
xlabel('n');
ylabel('x(n)');
title('OMP simulation');
grid on;

figure(2);
subplot(211);
plot(1:N, x, 'b', 'linewidth', 2);
grid on;

subplot(212);
plot(1:N, x, 'b', 'linewidth', 2); hold on;
plot(1:N, x_est_CoSaMP, 'g');
legend('ground truth','CoSaMP output');
xlabel('n');
ylabel('x(n)');
title('CoSaMP simulation');
grid on;

figure(3);
subplot(211);
plot(1:N, x, 'b', 'linewidth', 2);
grid on;

subplot(212);
plot(1:N, x, 'b', 'linewidth', 2); hold on;
plot(1:N, x_est_HTP, 'g');
legend('ground truth','HTP output');
xlabel('n');
ylabel('x(n)');
title('HTP simulation');
grid on;

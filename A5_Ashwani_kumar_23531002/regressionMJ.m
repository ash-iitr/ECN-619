
clc;
clear;
close all;
% Generating a random k-sparse vector x

N = 500;
k = 10;
x = zeros(N, 1);
support = randperm(N, k);
x(support) = randn(k, 1);
figure(1);
stem(x, 'b', 'LineWidth', 2);
xlabel('Index');
ylabel('Value');
title('Sparse Vector x');


% Generating a real-valued measurement matrix A and noisy measurement vector y

m = 100;
A = randn(m, N) / sqrt(m);
SNRs = [10, 15, 20, 25, 30]; % SNR values in dB
NMSE_OMP_avg = zeros(length(SNRs), 1);
NMSE_CoSAMP_avg = zeros(length(SNRs), 1);
NMSE_HTP_avg = zeros(length(SNRs), 1);
NSER_OMP_avg = zeros(length(SNRs), 1);
NSER_CoSAMP_avg = zeros(length(SNRs), 1);
NSER_HTP_avg = zeros(length(SNRs), 1);

for snr_idx = 1:length(SNRs)
    SNR_dB = SNRs(snr_idx);
    SNR_linear = 10^(SNR_dB / 10);
    sigma = sqrt(1 / SNR_linear);
    
    for trial = 1:50
        % Generate noisy measurement vector y
        e = sigma * randn(m, 1);
        y = A * x + e;
        
        % Perform OMP and CoSAMP recovery
        x_est_OMP = OMPMJ(y, A, k);
        x_est_CoSAMP = CoSaMPMJ(y, A, k);
        x_est_HTP = HTPMJ(y, A, k);
        
        % Compute NMSE and NSER for OMP
        NMSE_OMP = norm(x - x_est_OMP)^2 / norm(x)^2;
        NSER_OMP = length(setdiff(find(x), find(x_est_OMP))) + length(setdiff(find(x_est_OMP), find(x))) / length(find(x));
        
        % Compute NMSE and NSER for CoSAMP
        NMSE_CoSAMP = norm(x - x_est_CoSAMP)^2 / norm(x)^2;
        NSER_CoSAMP = length(setdiff(find(x), find(x_est_CoSAMP))) + length(setdiff(find(x_est_CoSAMP), find(x))) / length(find(x));
        
        % Compute NMSE and NSER for OMP
        NMSE_HTP = norm(x - x_est_HTP)^2 / norm(x)^2;
        NSER_HTP = length(setdiff(find(x), find(x_est_HTP))) + length(setdiff(find(x_est_HTP), find(x))) / length(find(x));
        
        % Accumulate NMSE and NSER values for averaging
        NMSE_OMP_avg(snr_idx) = NMSE_OMP_avg(snr_idx) + NMSE_OMP;
        NMSE_CoSAMP_avg(snr_idx) = NMSE_CoSAMP_avg(snr_idx) + NMSE_CoSAMP;
        NMSE_HTP_avg(snr_idx) = NMSE_HTP_avg(snr_idx) + NMSE_HTP;

        NSER_OMP_avg(snr_idx) = NSER_OMP_avg(snr_idx) + NSER_OMP;
        NSER_CoSAMP_avg(snr_idx) = NSER_CoSAMP_avg(snr_idx) + NSER_CoSAMP;
        NSER_HTP_avg(snr_idx) = NSER_HTP_avg(snr_idx) + NSER_HTP;
    end
    
    % Average NMSE and NSER values across trials
    NMSE_OMP_avg(snr_idx) = NMSE_OMP_avg(snr_idx) / 50;
    NMSE_CoSAMP_avg(snr_idx) = NMSE_CoSAMP_avg(snr_idx) / 50;
    NMSE_HTP_avg(snr_idx) = NMSE_HTP_avg(snr_idx) / 50;

    NSER_OMP_avg(snr_idx) = NSER_OMP_avg(snr_idx) / 50;
    NSER_CoSAMP_avg(snr_idx) = NSER_CoSAMP_avg(snr_idx) / 50;
    NSER_HTP_avg(snr_idx) = NSER_HTP_avg(snr_idx) / 50;
end
%

%%% Plotting the averaged NMSE as a function of SNR for OMP, CoSAMP and HTP
figure(2);
plot(SNRs, 10*log10(NMSE_OMP_avg), 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(SNRs, 10*log10(NMSE_CoSAMP_avg), 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(SNRs, 10*log10(NMSE_HTP_avg), 'c-*', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('SNR (dB)');
ylabel('Averaged NMSE (dB)');
legend('OMP','CoSAMP','HTP');
title('Averaged NMSE vs. SNR for OMP,CoSAMP and HTP');
grid on;

figure(3);
plot(SNRs, 10*log10(NSER_OMP_avg), 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(SNRs, 10*log10(NSER_CoSAMP_avg), 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
plot(SNRs, 10*log10(NSER_HTP_avg), 'c-*', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('SNR (dB)');
ylabel('Averaged NSER (dB)');
legend('OMP','CoSAMP','HTP');
title('Averaged NSER vs. SNR for OMP,CoSAMP and HTP');
grid on;
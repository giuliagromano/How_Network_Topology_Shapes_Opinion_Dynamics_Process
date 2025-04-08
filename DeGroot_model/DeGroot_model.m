%% Initialization 
N = 15;% Number of iterations

% Initial opinions
%x0 = rand(n, 1);
x0 = [0.6853, 0.6203, 0.7467, 0.9773, 0.3839, 0.2602, 0.8775, 0.8061, 0.4611, 0.0910, 0.5643, 0.1874, 0.5317, 0.3550, 0.3148];

A = dlmread('Ad_matrix.txt');
n = size(A,1); % Number of individuals

%% DeGroot Model Simulation
x = zeros(n, N);  
x(:, 1) = x0;     %initial opinions

for k = 2:N
    x(:, k) = A * x(:, k-1);
end

%% Calculate Consensus
[eigenvecs, eigenvals] = eig(A');  
w = eigenvecs(:, 1);  % left eigenvector corresponding to eigenvalue 1

% Normalize w
w = w / sum(w);  
 
consensus = (w' * x(:, 1)) * ones(n, 1);  % Calculate (w^T x_0) 1_n

%% Plot Opinions
figure;
plot(x', 'LineWidth', 0.5);  
hold on;
plot(1:N, consensus * ones(1, N), '--k', 'LineWidth', 2);  % Consensus 
xlabel('Iterations (k)');
ylabel('Opinions (x)');
title('Evolution of Individuals'' Opinions x(k)', 'FontSize', 16);
xlim([1 N]);  
legend([arrayfun(@(x) ['Individual ', num2str(x)], 1:n, 'UniformOutput', false), {'Consensus'}], 'Location','bestoutside');
grid on;
saveas(gcf, 'cons_15_degroot.jpg');
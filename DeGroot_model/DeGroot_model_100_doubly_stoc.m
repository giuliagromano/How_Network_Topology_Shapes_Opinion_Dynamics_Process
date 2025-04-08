%% Initialization 
N = 16;
x0 = dlmread('x0_100.txt');

A = dlmread('Ad_matrix_doubly_stochastic_100_2.txt');
n = size(A,1); 

%% DeGroot Model Simulation
x = zeros(n, N);  
x(:, 1) = x0;     

for k = 2:N
    x(:, k) = A * x(:, k-1);
end

%% Calculate Consensus
[eigenvecs, eigenvals] = eig(A');  
w = eigenvecs(:, 1);  

% Normalize w
w = w / sum(w);  
 
%consensus = (w' * x(:, 1)) * ones(n, 1);  % Calculate (w^T x_0) 1_n
average_consensus = (ones(n, 1)'*x(:, 1)) * ones(n, 1)/n;  % Calculate (1_n x_0) 1_n/n

%% Plot Opinions
figure;
p1 = plot(0:N-1, x', 'LineWidth', 0.5);  
hold on;
p2 = plot(0:N-1, average_consensus * ones(1, N), '--k', 'LineWidth', 2);  % Consensus 
xlabel('Iterations (k)');
ylabel('Opinions (x)');
title('Evolution of Individuals'' Opinions x(k)', 'FontSize', 16);
xlim([0 N-1]);  
labels = arrayfun(@(x) ['Individual ', num2str(x)], 1:20, 'UniformOutput', false);
labels{end+1} = '...';
legend([p1(1:21); p2], [labels, {'Average Consensus'}], 'Location', 'bestoutside');
grid on;
%saveas(gcf, 'cons_100_degroot_doubly_2.jpg');

%% Plot average
% fist_val = x(:, 1)*ones(1,N);
% figure;
% plot(fist_val', 'LineWidth', 0.5);
% hold on;
% plot(1:N, average_consensus * ones(1, N), '--k', 'LineWidth', 2);  
% xlabel('Iterations (k)');
% ylabel('Opinions (x)');
% title('Average of Initial Individuals'' Opinions', 'FontSize', 13);
% xlim([1 N]);  
% labels = arrayfun(@(x) ['Initial Op. - Individual ', num2str(x)], 1:20, 'UniformOutput', false);
% labels{end+1} = '...';
% labels{end+1} = 'Average';
% legend(labels, 'Location','bestoutside');
% grid on;
% %saveas(gcf, 'avg_100_degroot_doubly.jpg');

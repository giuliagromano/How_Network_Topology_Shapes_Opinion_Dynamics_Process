%% Initialization 
N = 100;
A = dlmread('Ad_matrix_nsc_multiple_sinks_prova2a.txt');

n = size(A,1); 
% x0 = rand(n, 1);
% writematrix(x0, 'x0_nsc_mult_2.txt', 'Delimiter', 'tab');
x0 = dlmread('x0_nsc_mult_2.txt');

%% DeGroot Model Simulation
x = zeros(n, N);  
x(:, 1) = x0;     

for k = 2:N
    x(:, k) = A * x(:, k-1);
end

%% Calculate Consensus
[eigenvectors, eigenvalues_matrix] = eig(A');  
eigenvalues = diag(eigenvalues_matrix); 

[rho, idx] = max(eigenvalues);

dominant_w = eigenvectors(:, idx);  

w1 = dominant_w(16:115) / sum(dominant_w(16:115));  
w2 = dominant_w(116:130) / sum(dominant_w(116:130));

consensus_dest1 = (w1' * x0(16:115)) * ones(100, 1);  % Calculate (w^T x_dest1) 1_n
consensus_dest2 = (w2' * x0(116:130)) * ones(15, 1);  % Calculate (w^T x_dest2) 1_n

%% Plot Opinions
figure;
p1 = plot(x', 'LineWidth', 0.5);  
hold on;
% consensus  
p2 = plot(1:N, consensus_dest1 * ones(1, N), '--k', 'LineWidth', 2); 
p3 = plot(1:N, consensus_dest2 * ones(1, N), '--r', 'LineWidth', 2);  
xlabel('Iterations (k)');
ylabel('Opinions (x)');
title('Evolution of Individuals'' Opinions x(k)', 'FontSize', 16);
xlim([1 N]); 
ylim([0 1]);  

text(N, mean(x(1:15,end)), 'Source', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right', 'FontSize', 7);
text(N, mean(x(16:115,end)), 'Destination1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 7);
text(N, mean(x(116:130,end)), 'Destination2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 7);
labels = arrayfun(@(x) ['Individual ', num2str(x)], 1:20, 'UniformOutput', false);
labels{end+1} = '...';  
%labels{end+1} = 'Consensus dest1';  
%labels{end+1} = 'Consensus dest2';  

%legend([p1(1:21); p2; p3], [labels, 'Consensus dest1', 'Consensus dest2'], 'Location', 'bestoutside');

% Create dummy lines for correct legend display of dashed lines with the right colors
dummyLineDest1 = plot(nan, nan, '--k', 'LineWidth', 2); 
dummyLineDest2 = plot(nan, nan, '--r', 'LineWidth', 2);  

legend([p1(1:21); dummyLineDest1; dummyLineDest2], [labels, 'Consensus dest1', 'Consensus dest2'], 'Location', 'bestoutside');
grid on;
%saveas(gcf, 'cons_degroot_nsc_multiple_sinks_prova2a.jpg');
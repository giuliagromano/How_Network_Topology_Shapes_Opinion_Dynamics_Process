%% Initialization 
N = 150;

A = dlmread('Ad_matrix_nsc.txt');
n = size(A,1); 

%x0 = rand(n, 1);
%writematrix(x0, 'x0_nsc.txt', 'Delimiter', 'tab');
x0 = dlmread('x0_nsc.txt');

%initial condition 120 -> x0 = [0.0019, 0.8578, 0.0100, 0.0087, 0.8405, 0.6111, 0.7700, 0.8572, 0.9335, 0.0151, 0.1898, 0.6941, 0.9773, 0.5753, 0.5624, 0.9418, 0.6864, 0.3312, 0.3401, 0.9344, 0.3075, 0.0388, 0.5678, 0.6508, 0.7387, 0.9564, 0.3061, 0.7591, 0.2813, 0.9019, 0.6706, 0.2915, 0.3235, 0.7168, 0.1842, 0.4403, 0.3645, 0.2135, 0.5335, 0.8323, 0.4728, 0.6324, 0.1970, 0.9975, 0.0023, 0.2813, 0.9019, 0.6706, 0.2915, 0.6153, 0.8245, 0.4141, 0.8963, 0.5120, 0.9617, 0.6079, 0.6661, 0.9215, 0.4487, 0.6333, 0.2115, 0.5603, 0.1036, 0.2923, 0.5440, 0.1809, 0.2761, 0.2326, 0.5488, 0.5570, 0.6205, 0.0007, 0.1878, 0.4728, 0.6324, 0.4763, 0.0182, 0.4749, 0.0766, 0.2507, 0.5812, 0.1510, 0.4102, 0.8930, 0.8544, 0.5428, 0.4605, 0.1494, 0.4889, 0.5691, 0.3415, 0.4179, 0.1768, 0.8348, 0.7052, 0.6758, 0.1854, 0.6111, 0.0100, 0.0087, 0.8405, 0.6111, 0.7700, 0.7052, 0.0283, 0.8578, 0.0100, 0.0087, 0.8405, 0.7052, 0.7700, 0.8572, 0.5209, 0.2591, 0.5082, 0.9732, 0.8182, 0.8588, 0.8966, 0.2995];

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

% Normalize w
w = dominant_w / sum(dominant_w); 
 
consensus = (w' * x(:, 1)) * ones(n, 1);  % Calculate (w^T x_0) 1_n

%% Plot w 
figure;

stem(1:110, w, 'filled', 'MarkerFaceColor', [0 0.5 0.8], 'Color', [0 0.5 0.8]);
hold on;

% first 10 elements
stem(1:10, w(1:10), 'filled', 'MarkerFaceColor','r' , 'Color', 'r');  

xlabel('Index of w');  
ylabel('Value of w');  
title('Plot of w associated to \rho(A)=1');  
grid on;
legend('Nodes of Source', 'Nodes of Destination', 'Location', 'best');
hold off;  
%saveas(gcf, 'w_100_degroot_nsc.jpg');

%% Plot Opinions
figure;
p1 = plot(x', 'LineWidth', 0.5);  
hold on;
p2 = plot(1:N, consensus * ones(1, N), '--k', 'LineWidth', 2);  % Consensus 
xlabel('Iterations (k)');
ylabel('Opinions (x)');
title('Evolution of Individuals'' Opinions x(k)', 'FontSize', 16);
xlim([1 N]);  
ylim([0 1]);  
labels = arrayfun(@(x) ['Individual ', num2str(x)], 1:20, 'UniformOutput', false);
labels{end+1} = '...';

dummyLineCons = plot(nan, nan, '--k', 'LineWidth', 2);  

legend([p1(1:21); dummyLineCons], [labels, 'Consensus'], 'Location', 'bestoutside');

grid on;
%saveas(gcf, 'cons_100_degroot_nsc.jpg');

%% Disagreement vector
disagreement = x(:,N)-consensus;
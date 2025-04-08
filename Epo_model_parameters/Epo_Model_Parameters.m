%% Initialization Parameters
%close all
%clear all
N = 31; % Number of iterations

A = dlmread('A_kleinberg.txt');
n = size(A, 1); % Number of individuals

G = digraph(A);

% Calculate clustering coefficient for each node
[clustering_coeff, overall_clustering_coeff] = calculateClusteringCoefficient(A);  

% Calculate average path length for each node
%[avg_path_length, overall_avg_path_length] = calculateAveragePathLength(G);

% Calculate closeness_centrality for each node
[closeness_centrality] = calculateClosenessCentrality(G);

% The adjacency matrix has to be row-stochastic
Ad = zeros(size(A));  
for i = 1:n
    row_sum = sum(A(i, :));
    if row_sum ~= 0
        Ad(i, :) = A(i, :) / row_sum;  % Normalize the row
    end
end

% Initial opinions
%x0 = rand(n, 1); % Initial opinions
%writematrix(x0, 'x0_all_to_all_15.txt', 'Delimiter', 'tab');  
x0 = dlmread('x0_nearest_neigh_6.txt');     

x_private = zeros(n, 1);
x_expressed = zeros(n, 1);

% Weights and offset for lambda_i and phi_i
a = 1;  
b = 0;  
u = 1;  
v = 0; 

%  u = zeros(n, 1);
% numb = 6;  
% for ii = 1:numb:n  
%      for j = 0:numb-1  
%          u(mod(ii+j-1, n) + 1) = 1- ii * 0.01;
%      end
%  end
%  stem(u);

lambda = zeros(n, 1);
phi = zeros(n, 1);

% lambda_i and phi_i for each node
for i = 1:n
    lambda(i) = a * clustering_coeff(i) + b;  % Susceptibility to influence
    phi(i) = 1 - (u* closeness_centrality(i) + v);  % Resistance to group pressure
end

%% Model 
x_private(:, 1) = x0;
x_expressed(:, 1) = x0;

% EPO Model
for k = 2:N
    % Public opinion
    x_avg = sum(x_expressed(:, k-1)) / n; 

    % Update expressed opinions
    x_expressed_new = zeros(n, 1);  
    for i = 1:n
        x_expressed_new(i) = phi(i) * x_private(i, k-1) + (1 - phi(i)) * x_avg; 
    end
    x_expressed(:, k) = x_expressed_new; 

    % Update private opinions
    x_private_new = zeros(n, 1);  
    for i = 1:n
        x_private_new(i) = lambda(i) * (Ad(i, i) * x_private(i, k-1) + sum(Ad(i, :) .* x_expressed(:, k)') - Ad(i, i) .* x_expressed(i, k)') + (1 - lambda(i)) * x0(i);  % Update private opinion
    end
    x_private(:, k) = x_private_new;  
end

 %% Visualizing the result
figure;
p1 = plot(0:N-1, x_private', 'LineWidth', 1);  
hold on;
p2 = plot(0:N-1, x_expressed', '--', 'LineWidth', 1);  
hold on;
%p4 = plot(0:N-1, x_private(1,:), 'Color', 'b', 'LineWidth', 3);  %Star Network
hold on;
p3 = plot(0:N-1, x_avg * ones(1, N), '-.k', 'LineWidth', 2);  
hold on;
%p5 = plot(0:N-1, x_expressed(1,:), '--', 'Color', 'b', 'LineWidth', 3);  %Star Network 

xlabel('Iterations');
ylabel('Opinions');
title(['Evolution of Individuals'' Opinions - EPO Model']);
subtitle(['Scale Free Network']);
xlim([0 N-1]);
grid on;

labels_private = arrayfun(@(x_private) ['Private Opinions ', num2str(x_private)], 1:10, 'UniformOutput', false);
labels_private{end+1} = '...';  
labels_expressed = arrayfun(@(x_expressed) ['Expressed Opinions ', num2str(x_expressed)], 1:10, 'UniformOutput', false);
labels_expressed{end+1} = '...';  
label_avg = '$\hat{x}_{avg}$';  
labels = [labels_private, labels_expressed];

%Star Network legend
%legend([p4; p1(2:12); p5; p2(2:12); p3], [{'Private Opinions 1'}, labels(1:11), {'Expressed Opinions 1'}, labels(12:22), {label_avg}], 'Location', 'bestoutside', 'Interpreter', 'latex');

legend([p1(1:11); p2(1:11); p3], [labels(1:22), {label_avg}], 'Location', 'bestoutside', 'Interpreter', 'latex');

%saveas(gcf, 'cons_epo_Scalef.jpg');

%% Visualizing lambda
figure;    
stem(lambda, 'filled', 'MarkerFaceColor', [0 0.5 0.8], 'Color', [0 0.5 0.8]);
hold on;
xlabel('Node Index');  
ylabel('Value of \lambda'); 
title('Susceptibility to influence (\lambda)', 'FontSize', 15);  
ylim([0 1]);
grid on;  
hold off;  
%saveas(gcf, 'lambda_epo_Scalef.jpg');

%% Visualizing phi
figure;    
stem(phi, 'filled', 'MarkerFaceColor', [0 0.5 0], 'Color', [0 0.5 0]);
hold on;
ylim([0 1]);
xlabel('Node Index');  
ylabel('Value of \phi'); 
title('Resistance to Group Pressure (\phi)', 'FontSize', 15); 
grid on;  
hold off;  
%saveas(gcf, 'phi_epo_Scalef.jpg');

%% Visualizing the result - Small World
% figure;
% p1 = plot(0:N-1, x_private', 'LineWidth', 1);  
% hold on;  
% p2 = plot(0:N-1, x_expressed', '--', 'LineWidth', 1);  
% p4 = plot(0:N-1, x_private(3,:), 'Color', 'b', 'LineWidth', 2.5);  
% p5 = plot(0:N-1, x_expressed(3,:), '--', 'Color', 'b', 'LineWidth', 2.5);  
% p6 = plot(0:N-1, x_private(40,:), 'Color', 'y', 'LineWidth', 2.5);  
% p7 = plot(0:N-1, x_expressed(40,:), '--', 'Color', 'y', 'LineWidth', 2.5);  
% p8 = plot(0:N-1, x_private(59,:), 'Color', 'g', 'LineWidth', 2.5);  
% p9 = plot(0:N-1, x_expressed(59,:), '--', 'Color', 'g', 'LineWidth', 2.5);  
% p3 = plot(0:N-1, x_avg * ones(1, N), '-.k', 'LineWidth', 2);  
% xlabel('Iterations');
% ylabel('Opinions');
% title(['Evolution of Individuals'' Opinions - EPO Model']);
% subtitle(['Small World Network']);
% xlim([0 N-1]);
% grid on;
% 
% labels_private = arrayfun(@(x_private) ['Private Opinions ', num2str(x_private)], 1:2, 'UniformOutput', false);
% labels_private_2 = arrayfun(@(x_private) ['Private Opinions ', num2str(x_private)], 4:5, 'UniformOutput', false);
% labels_expressed = arrayfun(@(x_expressed) ['Expressed Opinions ', num2str(x_expressed)], 1:2, 'UniformOutput', false);
% labels_expressed_2 = arrayfun(@(x_expressed) ['Expressed Opinions ', num2str(x_expressed)], 4:5, 'UniformOutput', false);
% labels_ecc = '...';  
% label_avg = '$\hat{x}_{avg}$';  
% labels = [labels_private, {'Private Opinions 3'}, labels_private_2, ...
%           {labels_ecc}, {'Private Opinions 40'}, {'Private Opinions 59'}, ...
%           {labels_ecc}, labels_expressed, {'Expressed Opinions 3'}, labels_expressed_2, ...
%           {labels_ecc}, {'Expressed Opinions 40'}, {'Expressed Opinions 59'}, ...
%           {labels_ecc},{label_avg}];
% legend([p1(1:2); p4; p1(4:5); p1(6); p6; p8; p1(70); p2(1:2); p5; p2(4:5); p2(6); p7; p9; p2(70); p3], ...
%     labels, 'Location', 'bestoutside', 'Interpreter', 'latex');


%% Scale Free
% figure;
% p4 = plot(0:N-1, x_private(36:100,:), 'Color', '#1E90FF', 'LineWidth', 1);  
% hold on;
% p5 = plot(0:N-1, x_expressed(36:100,:), '--', 'Color', '#FFA500', 'LineWidth', 1);  
% hold on;
% p1 = plot(0:N-1, x_private(1:35,:)', 'Color', '#006400','LineWidth', 1);  
% hold on;
% p2 = plot(0:N-1, x_expressed(1:35,:)', '--','Color', '#C71585', 'LineWidth', 1);  
% hold on;
% p3 = plot(0:N-1, x_avg * ones(1, N), '-.k', 'LineWidth', 3);  
% 
% xlabel('Iterations');
% ylabel('Opinions');
% title(['Evolution of Individuals'' Opinions - EPO Model']);
% subtitle(['Scale Free Network']);
% xlim([0 N-1]);
% grid on;
% 
% label_avg = '$\hat{x}_{avg}$'; 
% 
% legend([p1(1); p2(1); p4(1); p5(1); p3], [{'Private Hubs'}, {'Expressed Hubs'}, {'Private Peripherals'}, {'Expressed Peripherals'}, {label_avg}], 'Location', 'bestoutside', 'Interpreter', 'latex');

% saveas(gcf, 'cons_epo_Scalef_2.jpg');
% %% Visualizing lambda - Scale Free
% figure;    
% stem(lambda, 'filled', 'MarkerFaceColor', [0 0.5 0.8], 'Color', [0 0.5 0.8]);
% hold on;
% stem(1:35, lambda(1:35), 'filled', 'MarkerFaceColor','#C71585' , 'Color', '#C71585');  
% xlabel('Node Index');  
% ylabel('Value of \lambda'); 
% title('Susceptibility to influence (\lambda)', 'FontSize', 15);  
% legend('Peripherals', 'Hubs', 'Location', 'northwest');
% ylim([0 1]);
% grid on;  
% hold off;  
% saveas(gcf, 'lambda_epo_Scalef_2.jpg');
% 
% %% Visualizing phi - Scale Free
% figure;    
% stem(phi, 'filled', 'MarkerFaceColor', [0 0.5 0], 'Color', [0 0.5 0]);
% hold on;
% stem(1:35, phi(1:35), 'filled', 'MarkerFaceColor','#FFA500' , 'Color', '#FFA500');  
% ylim([0 1]);
% xlabel('Node Index');  
% ylabel('Value of \phi');  
% title('Resistance to Group Pressure (\phi)', 'FontSize', 15); 
% legend('Peripherals', 'Hubs', 'Location', 'northwest');
% grid on;  
% hold off;  
% saveas(gcf, 'phi_epo_Scalef_2.jpg');
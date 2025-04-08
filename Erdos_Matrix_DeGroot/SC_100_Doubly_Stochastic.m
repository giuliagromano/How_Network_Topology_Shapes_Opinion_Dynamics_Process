%% Initialization
% Number of individuals
n = 100;

% % Probability of connection between individuals (Erdős-Rényi model)
% p = 0.3;
% 
% %% Generate Adjacency Matrix
% % Random Erdős-Rényi graph
% A = rand(n) < p;  
% % avoid empty rows
% for i = 1:n
%     if sum(A(i, :)) == 0
%         A(i, randi(n)) = 1;
%     end
% end

A = dlmread('Ad_matrix_100.txt');

%% Convertion of A to Double Stochastic Matrix 
Ad = double(A);  
tolerance = 1e-5;       %tolerance
max_iter = 1000;  
iter = 0;
while iter < max_iter
    iter = iter + 1;
    
    % Row normalization 
    Ad = Ad ./ sum(Ad, 2);
    % Column normalization
    Ad = Ad ./ sum(Ad, 1);
    
    % Check
    row_sum_diff = max(abs(sum(Ad, 2) - 1));
    col_sum_diff = max(abs(sum(Ad, 1) - 1));
    
    if row_sum_diff < tolerance && col_sum_diff < tolerance
        break;
    end
end

% disp('Sum of each row (should be close to 1):');
% disp(sum(Ad, 2));  
% 
% disp('Sum of each column (should be close to 1):');
% disp(sum(Ad, 1));  

writematrix(Ad, 'Ad_matrix_doubly_stochastic_100.txt', 'Delimiter', 'tab');

%% Graph
G = digraph(Ad);
figure;
plot(G, 'EdgeColor',[1 0 0]);
title(['Social Graph - ' num2str(n) ' individuals (Doubly Stochastic)'], 'FontSize', 16);
saveas(gcf, 'net_100_doubly_stochastic_2.jpg');

%% Condensation graph
C = condensation(G);
figure;
plot(C, 'EdgeColor',[1 0 0]);
title('Condensation digraph (Strongly Connected Components)', 'FontSize', 13);
saveas(gcf, 'cond_100_doubly_stochastic_2.jpg');

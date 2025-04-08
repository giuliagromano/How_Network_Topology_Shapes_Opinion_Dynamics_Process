%% Initialization
% Number of individuals
n = 100;

% Probability of connection between individuals (Erdős-Rényi model)
p = 0.3;

%% Generate Adjacency Matrix
% Random Erdős-Rényi graph
A = rand(n) < p;  
% avoid empty rows
for i = 1:n
    if sum(A(i, :)) == 0
        % If there are no connections, connect to a random node
        A(i, randi(n)) = 1;
    end
end

%% A Row-Stochastic Matrix
Ad = zeros(size(A)); 
for i = 1:n
    row_sum = sum(A(i, :));
    if row_sum ~= 0
        Ad(i, :) = A(i, :) / row_sum;  % Normalize the row
    end
end

% Verify that each row sums to 1
disp('Sum of each row (should be 1):');
disp(sum(Ad, 2));  

isPrimitive = checkPrimitivity(Ad);

writematrix(Ad, 'Ad_matrix_100.txt', 'Delimiter', 'tab');

%% Graph
G = digraph(Ad);

figure;
plot(G, 'EdgeColor',[1 0 0], 'EdgeAlpha', 0.2, 'Layout', 'force');
title(['Social Graph - ' num2str(n) ' individuals'], 'FontSize', 16);
saveas(gcf, 'net_100.jpg');

%%  Condensation Graph 
C = condensation(G);

figure;
plot(C, 'EdgeColor',[1 0 0]);
title('Condensation digraph (Strongly Connected Components)', 'FontSize', 13);
saveas(gcf, 'cond_100.jpg');

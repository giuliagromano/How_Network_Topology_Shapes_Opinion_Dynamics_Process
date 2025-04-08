%% Initialization
p = 0.3;

%% Generate Adjacency Matrix
A_22 = dlmread('Ad_matrix_100.txt');  
n_dest = size(A_22,1); 

n_sc = 10;

n = n_dest + n_sc;

%A_11 = ones(diff, diff);
A_11 = rand(n_sc) < p;
for i = 1:n_sc
    A_11(i, i) = 0;
end

A_12 = zeros(n_sc,n_dest);
%A_12(1,:) = 1;
A_12(1,1) = 1;
 
A_21 = zeros(n_dest,n_sc);

A = [A_11,A_12; A_21 A_22];

%% Row-Stochastic Matrix
Ad = zeros(size(A));  % Initialize the row-stochastic matrix
for i = 1:n
    row_sum = sum(A(i, :));
    if row_sum ~= 0
        Ad(i, :) = A(i, :) / row_sum;  % Normalize the row
    end
end

disp('Sum of each row (should be 1):');
disp(sum(Ad, 2));  

isPrimitive = checkPrimitivity(Ad);

writematrix(Ad, 'Ad_matrix_nsc.txt', 'Delimiter', 'tab');

%% Graph
G = digraph(Ad);

figure;
plot(G, 'EdgeColor',[1 0 0]);
title(['Social Graph Non-Strongly Connected - ' num2str(n) ' individuals'], 'FontSize', 14);
subtitle('One Destination');

saveas(gcf, 'net_110_nsc.jpg');

%% Condensation Graph
C = condensation(G);

figure;
plot(C, 'EdgeColor',[1 0 0]);
title('Condensation digraph (Non-Strongly Connected)', 'FontSize', 13);
saveas(gcf, 'cond_110_nsc.jpg');

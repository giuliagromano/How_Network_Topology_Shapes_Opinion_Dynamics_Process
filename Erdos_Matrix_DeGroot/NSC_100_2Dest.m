%% Initialization
n_source = 15;

p = 0.3;

%% Generate Adjacency Matrix

A_dest1 = dlmread('Ad_matrix_100.txt');  
n_dest1 = size(A_dest1,1);

A_dest2 = dlmread('Ad_matrix.txt');      
n_dest2 = size(A_dest2,1); 

n_sc = n_dest1 + n_dest2;

% % Non strongly connected part

while true
    A_source = (rand(n_source) < p);  
    G_source = digraph(A_source);  
    if numel(unique(conncomp(G_source, 'Type', 'strong'))) == 1
        break;  % Esce dal ciclo se c'è una sola comp. connessa
    end
end

A_12 = zeros(n_source,n_sc);
for k = 1:2:n_source
    for j = 1:10:n_dest1
        A_12(k,j) = 1;
    end
end

A_12(1, n_dest1+1) = 1;

A_21_dest1 = zeros(n_dest1,n_dest2);
A_21_dest2 = zeros(n_dest2,n_dest1);

A = [A_source,A_12;zeros(n_dest1,n_source),A_dest1,A_21_dest1;zeros(n_dest2,n_source),A_21_dest2,A_dest2];

n = n_source + n_dest1 + n_dest2;
%%  Row-Stochastic Matrix
Ad = zeros(size(A));  
for i = 1:n
    row_sum = sum(A(i, :));
    if row_sum ~= 0
        Ad(i, :) = A(i, :) / row_sum;  % Normalize the row
    end
end
disp('Sum of each row (should be 1):');
disp(sum(Ad, 2));  

isPrimitive = checkPrimitivity(Ad);

writematrix(Ad, 'Ad_matrix_nsc_multiple_sinks.txt', 'Delimiter', 'tab');

%% Graph
G = digraph(Ad);

figure;

color1 = [0.0, 0.0, 0.5];  
color2 = [0.5, 1.0, 0.0];  
color3 = [1.0, 1.0, 0.0];  

nodeColors = zeros(n, 3);  
nodeColors(1:15, :) = repmat(color1, 15, 1);  
nodeColors(16:115, :) = repmat(color2, 100, 1);  
nodeColors(116:130, :) = repmat(color3, 15, 1);  

p = plot(G, 'NodeColor', nodeColors, 'EdgeColor', [1 0 0], 'EdgeAlpha', 0.2);
title(['Social Graph Non-Strongly Connected - ' num2str(n) ' individuals'], 'FontSize', 14);
subtitle('Multiple Sinks');
hold on;
h1 = scatter(nan, nan, 36, color1, 'filled'); % Dummy plot for legend
h2 = scatter(nan, nan, 36, color2, 'filled'); % Dummy plot for legend
h3 = scatter(nan, nan, 36, color3, 'filled'); % Dummy plot for legend
legend([h1 h2 h3], {'Source Nodes', 'Destination 1 Nodes', 'Destination 2 Nodes'}, 'Location', 'best');

saveas(gcf, 'net_nsc_multiple_sinks_a.jpg');

%% Graph Condensation
C = condensation(G);
numComponents = max(C.Edges.EndNodes(:));  
componentColors = zeros(numComponents, 3);  

componentColors(1, :) = color1;  
componentColors(2, :) = color2;
componentColors(3, :) = color3;  

figure
p = plot(C, 'NodeColor', componentColors, 'EdgeColor', [1 0 0], 'EdgeAlpha', 0.2, 'MarkerSize', 5, 'LineWidth', 1.5);
title('Condensation digraph (Non-Strongly Connected)', 'FontSize', 13);
subtitle('Multiple Sinks');
hold on;
h1 = scatter(nan, nan, 36, color1, 'filled'); % Dummy plot for legend
h2 = scatter(nan, nan, 36, color2, 'filled'); % Dummy plot for legend
h3 = scatter(nan, nan, 36, color3, 'filled'); % Dummy plot for legend
legend([h1 h2 h3], {'Source', 'Destination 1', 'Destination 2'}, 'Location', 'best');
saveas(gcf, 'cond_nsc_multiple_sinks_a.jpg');

%% Max eigenvalue of A to check if it's simple
[eigenvectors, eigenvalues_matrix] = eig(Ad');  % Transpose A to get the left eigenvector
eigenvalues = diag(eigenvalues_matrix);  

[rho, idx] = max(eigenvalues);

alg_multiplicity = sum(abs(eigenvalues - rho) < 1e-10);

null_space = null(Ad - rho*eye(size(Ad)));
geom_multiplicity = size(null_space, 2); 

fprintf('Dominant eigenvalue (rho): %f\n', rho);
fprintf('Algebraic Multiplicity of rho: %d\n', alg_multiplicity);
fprintf('Geometric Multiplicity of rho: %d\n', geom_multiplicity);

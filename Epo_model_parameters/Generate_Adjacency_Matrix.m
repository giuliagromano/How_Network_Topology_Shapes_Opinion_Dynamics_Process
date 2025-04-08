%% Initialization
%close all;
%clear all;

n = 100;

%% Generate Adjacency Matrix
%ALL-TO-ALL
% A = ones(n, n);
% for i = 1:n
%     A(i, i) = 0;  % no self-loop
% end
% 

%STAR NETWORK
% A = zeros(n,n);
% for i = 1:n
%     A(i, 1) = 1;
%     %A(1, i) = 1;
%     A(i, i) = 0;
% end

% NEAREST NEIGHBOURS
% k = 6;  
% A = zeros(n, n);
% for i = 1:n
%     for j = 1:k/2
%         % Connect to the neighbors 
%         A(i, mod(i+j-1, n) + 1) = 1;
%         A(i, mod(i-j-1, n) + 1) = 1; 
%     end
% end

% % Erdos
% p = 0.1;  
% A = rand(n) < p;
% for i = 1:n
%     A(i, i) = 0;
% end 

% Prova con un nodo molto distante
% N = 15;
% A = zeros(N,N);
% for i = 1:n
%     for j = 1:n
%         A(i, j) = 1;
%     end
% end
% 
% for i = 1:n
%     A(i, i) = 0;
% end
% A(1,n+1)=1; A(n+1,n+2)=1; A(n+2,n+3)=1; A(n+3,n+4)=1; A(n+4,n+5)=1;
% A(n+1,1)=1; A(n+2,n+1)=1; A(n+3,n+2)=1; A(n+4,n+3)=1; A(n+5,n+4)=1; 

%Small World Network
% k = 6;
% p = 0.015;
% A = WattsStrogatz(n,k,p);

%Scale-free Network
mlinks = 2;
A = zeros(n,n);
A = Scale_Free(n, mlinks);

%% Transform to Row-Stochastic Matrix
Ad = zeros(size(A)); 
for i = 1:n
    row_sum = sum(A(i, :));
    if row_sum ~= 0
        Ad(i, :) = A(i, :) / row_sum;  % Normalize the row
    end
end

writematrix(A, 'A_Scalef.txt', 'Delimiter', 'tab');

%% Graph 
G = digraph(A);  

figure;
plot(G, 'EdgeColor',[1 0 0]);
title(['Social Graph - Star Network'], 'FontSize', 16);
%saveas(gcf, 'net_Star_3.jpg');

%% Network properties
[avg_path_length, overall_avg_path_length] = calculateAveragePathLength(G);

[clustering_coeff, overall_clustering_coeff] = calculateClusteringCoefficient(A);  

[closeness_centrality] = calculateClosenessCentrality(G)

disp('Average Path Length for each node (d_i):');
disp(avg_path_length);

disp('Clustering Coefficient for each node (c_i):');
disp(clustering_coeff);

disp('Closeness Centrality for each node (centrality_i):');
disp(closeness_centrality);

disp('Overall Average Path Length of the network:');
disp(overall_avg_path_length);

disp('Overall Clustering Coefficient of the network:');
disp(overall_clustering_coeff);
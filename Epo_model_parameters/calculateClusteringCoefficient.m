function [C, overall_clustering_coeff] = calculateClusteringCoefficient(Ad)
    % Initialization
    n = size(Ad, 1);
    C = zeros(n, 1);
    
    for i = 1:n
        % neighbors of node i
        neighbors = find(Ad(i, :));
        % Degree of node i
        k_i = length(neighbors);
        
        if k_i > 1
            % the number of edges between the neighbors of node i
            subgraph = Ad(neighbors, neighbors);
            actual_edges = sum(subgraph(:)) / 2;
            
            % Maximum possible number of edges between neighbors
            max_edges = k_i * (k_i - 1) / 2;
            
            % Clustering coefficient for node i
            C(i) = actual_edges / max_edges;
        else
            % If node i has 0 or 1 neighbor, clustering coefficient is 0
            C(i) = 0;
        end
    end
    overall_clustering_coeff = mean(C);
end

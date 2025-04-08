function [avg_path_length, overall_avg_path_length] = calculateAveragePathLength(G)
    n = numnodes(G);
    
    % Initialization
    avg_path_length = zeros(n, 1); 
    overall_avg_path_length = 0;   

    D = distances(G); % distances between nodes in G

    % the average path length for each node i
    for i = 1:n
        % distances from node i to all other nodes
        dist_from_i = D(i, :);
        
        % Exclude the distance to itself
        dist_from_i(i) = [];
        
        % Average path length
        avg_path_length(i) = mean(dist_from_i(dist_from_i < Inf));
       
        overall_avg_path_length = overall_avg_path_length + sum(dist_from_i);
    end

    % the overall average path length of the network
    overall_avg_path_length = overall_avg_path_length / (n * (n - 1)); 
end

function [closeness_centrality] = calculateClosenessCentrality(G)
    
    n = numnodes(G);  

    dist_matrix = distances(G); % distances between nodes in G
   
    closeness_centrality = zeros(n, 1);
    
    % closeness_centrality for each node i
    for i = 1:n
        
        dist_from_i = dist_matrix(i, :);
        
        finite_distances = dist_from_i(isfinite(dist_from_i) & dist_from_i > 0);        %only finite distances
       
        if ~isempty(finite_distances)
            closeness_centrality(i) = (length(finite_distances)-1) / sum(finite_distances);  
        else
            closeness_centrality(i) = 0;  
        end
    end
    
    %to have closeness_centrality between 0 and 1
    if max(closeness_centrality) - min(closeness_centrality) > 0
        closeness_centrality = (closeness_centrality - min(closeness_centrality))/(max(closeness_centrality) - min(closeness_centrality));
    else
        closeness_centrality = ones(size(closeness_centrality));    %if all values are equal -> set closeness_centrality = 1
    end

end

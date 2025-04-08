function isAperiodic = checkAperiodicity(A)
    [rows, cols] = size(A);
    if rows ~= cols     %Check Matrix square
        error('The matrix is not square.');
    end
    
    Max_lim = rows; 
    isAperiodic = false; 
    
    %reachable nodes
    reachable = zeros(rows, rows); 

    for k = 1:Max_lim
        Ak = A^k; 
        reachable = reachable | (Ak > 0); 
        
        % Check all nodes can reach each other
        if all(reachable, 'all')
            isAperiodic = true; 
            break; 
        end
    end
    if isAperiodic
        disp('The matrix is aperiodic.');
    else
        disp('The matrix is not aperiodic.');
    end
end

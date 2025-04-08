function isPrimitive = checkPrimitivity(A)
  
    [rows, cols] = size(A);
    if rows ~= cols     %Check Matrix square
        error('The matrix is not square.');
    end
    
    if any(A(:) < 0)     %Check Matrix nonnegative
        error('The matrix contains negative values.');
    end
    
    Max_lim = 100; 

    for k = 1:Max_lim
        Ak = A^k; 
        if all(Ak(:) > 0)       %Primitive condition
            isPrimitive = true;         
            disp('The matrix is primitive.');
            return;
        end
    end
    
    isPrimitive = false;
    disp('The matrix is not primitive.');
end

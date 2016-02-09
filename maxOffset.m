function offset = maxOffset(bonds, leadVector)
    
    N = length(bonds);
    offset = zeros(1, N);
    
    for j = 2:N
        
        middleBond = [ bonds{1}(:,1) bonds{j}(:,2) ];
        middleVector = middleBond(:,2) - middleBond(:,1);
        
        offset(j) = norm(cross(middleVector, leadVector))/norm(leadVector);
        
    end
    
    offset = max(offset);
    
end

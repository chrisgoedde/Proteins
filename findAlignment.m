function [ leadBond, middleBond, tailBond, alignment, offset ] = findAlignment(bonds, twistLinks)
    
    N = length(bonds);
    
    if isEven(twistLinks(1))
        
        leadBond = [ bonds{1}(:,1) bonds{twistLinks(1)}(:,2) ];
        
    else
        
        leadBond = [ bonds{2}(:,1) bonds{twistLinks(1)}(:,2) ];
        
    end
    
    if isEven(N-twistLinks(end))
        
        tailBond = [ bonds{twistLinks(end)+1}(:,2) bonds{end-1}(:,2) ];
        
    else
        
        tailBond = [ bonds{twistLinks(end)+1}(:,2) bonds{end}(:,2) ];
        
    end
    
    middleBond = [ bonds{twistLinks(1)+1}(:,1) bonds{twistLinks(end)+1}(:,2) ];
    
    leadVector = leadBond(:,2) - leadBond(:,1);
    tailVector = tailBond(:,2) - tailBond(:,1);
    
    alignment = (leadVector' * tailVector)/(norm(leadVector)*norm(tailVector));
    offset = maxOffset(bonds, leadVector);
    
end

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

function value = isEven(argument)
    
    value = mod(argument, 2) == 0;
    
end

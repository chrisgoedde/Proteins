function extent = findExtent(bonds)
    
    totalVector = bonds{end}(:,2) - bonds{1}(:,1);
    extent = sqrt(totalVector' * totalVector);
    
end
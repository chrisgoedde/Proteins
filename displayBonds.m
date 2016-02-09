function displayBonds(bonds, theta, phi)
    
    for i = 1:length(bonds)

        vector = bonds{i}(:,2);
        fprintf('For bond %d, [ theta, phi ] = [ %.2f, %.2f ], [ X, Y, Z ] = [ %.2f, %.2f, %.2f ]\n', i, ...
            theta(i), phi(i), vector(1), vector(2), vector(3))
    
    end
    
end
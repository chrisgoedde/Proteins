function viewBonds(N, l, theta)
    
    % This function constructs a chain of N bonds and plots it. The input
    % parameters are
    % N = number of bonds in the chain
    % l = length of each bond
    % theta = fixed bond angle
    
    % We start by picking phi = 0 for all the bonds
    
    phi = zeros(1, N);
    theta = theta*pi/180;
    
    % Construct a chain of bonds. Each bond is described by a 3x2 matrix.
    % The first column of this matrix is the tail of the vector that
    % describes the bond, while the second column is the head of that
    % vector. The variable bonds is a cell array that holds the N matrices
    % that describe all the bonds in the chain.
    
    bonds = findBonds(N, l, theta, phi);
    
    % plot the bonds on a 3d plot. The phi values are used to color the
    % bonds.
    
    p = plotBonds([], bonds, phi);
    
    while true
        
        % Ask for input of a vector of bond indices to change the values of
        % phi.
        
        index = input('Vector of bonds: ');
        
        if isempty(index)
            
            break
            
        end
        
        % Ask for a set of new phi values for the bonds we want to change.
        
        angles = input('Angles of bonds: ');
        if size(angles) ~= size(index)
            
            disp('Please specify the same number of bonds and angles');
            break
            
        elseif isempty(angles)
            
            break
            
        end
        
        phi(index) = angles*pi/180;
        
        % Recalculate the bonds based on the new values of phi and replot
        % the entire chain.
        
        bonds = findBonds(N, l, theta, phi);
        p = plotBonds(p, bonds, phi);
        
    end
    
    close(gcf)
    
end


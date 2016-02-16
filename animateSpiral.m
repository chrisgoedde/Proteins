function animateSpiral(theta0, phi0)
    
    N = 30;
    l = 1;
    theta = theta0 * ones(1, N);
    phi = phi0 * ones(1, N);
    dphi = 5;
    
    bonds = findBonds(N, l, theta, phi);
    regularExtent = findExtent(bonds);
    
    while true
        
        % Ask for input of a vector of bond indices to change the values of
        % phi.
        
        twistLinks = input('Vector of bonds: ');
        
        if isempty(twistLinks)
            
            break
            
        end
        
        % Ask for a set of new phi values for the bonds we want to change.
        
        dir = input('Direction of rotation: ');
        if size(dir) ~= size(twistLinks)
            
            disp('Please specify the same number of bonds and angles');
            break
            
        elseif isempty(dir)
            
            break
            
        end
        
        phi = phi0 * ones(1, N);
        bonds = findBonds(N, l, theta, phi);
        
        figHandle = figure('KeyPressFcn', @startAnimation);
        
        p = plotBonds([], bonds, phi, phi0);
        % displayBonds(bonds, theta, phi)
        view(-60, 15)
        axis([ 0 30 -15 15 -15 15 ])
    
        startAnimation([], true)
        
        while ishandle(figHandle)
        
            % Recalculate the bonds based on the new values of phi and replot
            % the entire chain.
            
            phi(twistLinks) = phi(twistLinks) + dphi*dir;
        
            bonds = findBonds(N, l, theta, phi);
            p = plotBonds(p, bonds, phi, phi0);
            plot3(bonds{end}(1,2), bonds{end}(2,2), bonds{end}(3,2), 'b.')
            
            [ ~, ~, ~, alignment, offset ] = findAlignment(bonds, twistLinks);
            extent = findExtent(bonds);
            title(sprintf('alignment = %.1f degrees, radius = %.2f, shrinkage = %.2f', ...
                180*acos(alignment)/pi, offset, regularExtent-extent))
            
            drawnow
            % displayBonds(bonds, theta, phi)
            
        end
        
        close(gcf)

    end
    
end
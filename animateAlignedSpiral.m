function animateAlignedSpiral(numTwists, theta0, phi0)
    
    N = 30;
    l = 1;
    theta = theta0 * ones(1, N);
    phi = phi0 * ones(1, N);
    phid = phi0;
    dphi = 1;
    
    options = optimset('tolx', 0.001);
    
    firstTwist = N/2 - floor(numTwists/2)+1;
    twistLinks = firstTwist:(firstTwist+numTwists-1);
    
    bonds = findBonds(N, l, theta, phi);
    regularExtent = findExtent(bonds);
    
    phi = phi0 * ones(1, N);
    bonds = findBonds(N, l, theta, phi);
    
    figHandle = figure('KeyPressFcn', @startAnimation);
    pos = get(gcf, 'position');
    pos(3) = pos(3)*1.5;
    pos(4) = pos(4)*1.5;
    set(gcf, 'position', pos)
    
    p = plotBonds([], bonds, phi, phi0);
    % displayBonds(bonds, theta, phi)
    view(-60, 15)
    axis([ 0 30 -15 15 -15 15 ])
    
    savePhi = [ phi(firstTwist-1), phi(twistLinks) ];
    
    startAnimation([], true)
    
    while ishandle(figHandle)
        
        % Recalculate the bonds based on the new values of phi and replot
        % the entire chain.
        
        phid = phid + dphi;
        
        [ newPhi, ~, ~ ] = fminsearch(@(x) testAlignment(x, N, 1, theta0, phi0, phid, numTwists), phi(twistLinks), options);
        
        phi(twistLinks) = newPhi;
        phi(firstTwist-1) = phid;
        
        savePhi = [ savePhi ; phi(firstTwist-1) newPhi ]; %#ok<AGROW>
        
        bonds = findBonds(N, l, theta, phi);
        p = plotBonds(p, bonds, phi, phi0);
        plot3(bonds{end}(1,2), bonds{end}(2,2), bonds{end}(3,2), 'b.')
        
        titleLine = [ '\phi_d = ' sprintf('%.1f', phid) ', \phi: [ ' ];
        for j = 1:numTwists
            titleLine = [ titleLine sprintf('%.1f ', phi(twistLinks(j))) ]; %#ok<AGROW>
        end
        titleLine = [ titleLine ']' ]; %#ok<AGROW>
        
        [ ~, ~, ~, alignment, offset ] = findAlignment(bonds, twistLinks);
        extent = findExtent(bonds);
        title({ sprintf('alignment = %.1f degrees, radius = %.2f, shrinkage = %.2f', ...
            180*acos(alignment)/pi, offset, regularExtent-extent) ; titleLine })
        
        drawnow
        % displayBonds(bonds, theta, phi)
        
    end
    
    figure
    hold on, grid on
    
    [ r, c ] = size(savePhi);
    t = (1:r) - 1;
    
    for i = 1:c
        
        plot(t, savePhi(:, i))
        
    end
    
    pause
    
    close(gcf)
    
end
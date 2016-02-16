function viewSpiral(angleFile, angleCutoff, offsetCutoff)
    
    l = 1;
    
    angleList = []; theta0 = []; phi0 = []; twistLinks = []; N = [];
    saveFolder = sprintf('../Data/angle = %d/radius = %.1f', angleCutoff, offsetCutoff);
    saveFile = sprintf('%s/%s.mat', saveFolder, angleFile);
    
    if ~exist(saveFile, 'file')
        
        fprintf('Can''t find file %s.\n', saveFile)
        return
    end
    load(saveFile);
    
    [ numAngles, numTwists ] = size(angleList);
    
    fprintf('There are %d sets of angles in file %s.mat.\n', numAngles, angleFile)
    
    phi = phi0 * ones(1, N);
    regularBonds = findBonds(N, l, theta0 * ones(1, N), phi);
    regularExtent = findExtent(regularBonds);
    
    for i = 1:numAngles
        
        phi = phi0 * ones(1, N);
        phi(twistLinks) = angleList(i,:);
        
        bonds = findBonds(N, l, theta0 * ones(1, N), phi);
        [ leadBond, middleBond, tailBond, alignment, offset ] = findAlignment(bonds, twistLinks);
        extent = findExtent(bonds);
        
        if i == 1
            
            p = plotBonds([], bonds, phi, phi0);
            
            pos = get(gcf, 'position');
            pos(3) = pos(3)*1.5;
            pos(4) = pos(4)*1.5;
            set(gcf, 'position', pos)
            
        else
            
            p = plotBonds(p, bonds, phi, phi0);
            
        end
        
        hold on
        
        lp = plot3(leadBond(1, :), leadBond(2, :), leadBond(3, :), 'y-', 'linewidth', 4);
        tp = plot3(tailBond(1, :), tailBond(2, :), tailBond(3, :), 'y-', 'linewidth', 4);
        mp = plot3(middleBond(1, :), middleBond(2, :), middleBond(3, :), 'g-', 'linewidth', 4);
        
        titleLine = 'Phi: [ ';
        for j = 1:numTwists
            titleLine = [ titleLine sprintf('%.1f ', angleList(i, j)) ]; %#ok<AGROW>
        end
        titleLine = [ titleLine ']' ]; %#ok<AGROW>
        title({ sprintf('alignment = %.1f degrees, radius = %.2f, shrinkage = %.2f', ...
            180*acos(alignment)/pi, offset, regularExtent-extent) ; titleLine })
        
        view(135, 25)
        pause
        delete(lp), delete(tp), delete(mp)
        
    end
    
    close(gcf)
    
end
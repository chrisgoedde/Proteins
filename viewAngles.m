function viewAngles(angleFile)
    
    N = 20;
    l = 1;
    
    angleList = [];
    saveFile = sprintf('../Data/%s', angleFile);
    load(saveFile);
    
    [ numAngles, numTwists ] = size(angleList);
    twistLinks = 4:(4+numTwists-1);
    
    fprintf('There are %d sets of angles in file %s.mat.\n', numAngles, angleFile)
    
    for i = 1:numAngles
        
        phi = [ zeros(1,3) angleList(i,:) zeros(1, N-(numTwists+3)) ];
        
        bonds = findBonds(N, l, 30*pi/180, phi);
        
        if isEven(twistLinks(1))
            
            leadBond = [ bonds{1}(:,1) bonds{twistLinks(1)}(:,2) ];
            
        else
            
            leadBond = [ bonds{2}(:,1) bonds{twistLinks(1)}(:,2) ];
            
        end
        
        middleBond = [ bonds{twistLinks(1)+1}(:,1) bonds{twistLinks(end)+1}(:,2) ];
        
        if isEven(N-twistLinks(end))
            
            tailBond = [ bonds{twistLinks(end)+1}(:,2) bonds{end-1}(:,2) ];
            
        else
            
            tailBond = [ bonds{twistLinks(end)+1}(:,2) bonds{end}(:,2) ];
            
        end
        
        if i == 1
            
            p = plotBonds([], bonds, phi);
            
        else
            
            p = plotBonds(p, bonds, phi);
            
        end
        
        hold on
        
        % lp = plot3(leadBond(1, :), leadBond(2, :), leadBond(3, :), 'y-', 'linewidth', 4);
        % tp = plot3(tailBond(1, :), tailBond(2, :), tailBond(3, :), 'y-', 'linewidth', 4);
        % mp = plot3(middleBond(1, :), middleBond(2, :), middleBond(3, :), 'g-', 'linewidth', 4);
        
        titleLine = 'Phi: [ ';
        for j = 1:numTwists
            titleLine = [ titleLine sprintf('%.1f ', angleList(i, j)*180/pi) ]; %#ok<AGROW>
        end
        titleLine = [ titleLine ']' ]; %#ok<AGROW>
        title(titleLine)
        
        pause
        % delete(lp), delete(tp), delete(mp)
        
    end
    
    close(gcf)
    
    function value = isEven(argument)
        
        value = mod(argument, 2) == 0;
        
    end
    
end
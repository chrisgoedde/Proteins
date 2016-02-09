function findSpiral(theta0, phi0, twistLinks)
    
    N = 30;
    l = 1;
    theta = theta0 * ones(1, N);
    
    numTwists = length(twistLinks);
    
    count = 0;
    
    numAngles = 3;
    angleSet = linspace(0, 360, numAngles+1) + phi0;
    angleSet = angleSet(1:end-1);
    
    phi = phi0 * ones(1, N);
    numTries = numAngles^numTwists;
    angleList = [];
    
    for i = 1:numTries
        
        if ~mod(i, 1000)
            
            fprintf('Starting attempt %d of %d\n', i, numTries)
            
        end
        
        twistIndices = findAngles;
        
        twistAngles = angleSet(twistIndices);
        
        phi(twistLinks) = twistAngles;
        
        bonds = findBonds(N, l, theta, phi);
        
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
        
        % fprintf('alignment = %.2f\n', alignment)
        
        if abs(1-alignment) < 0.0001
            
            numTwists = length(twistLinks);
            
            offset = maxOffset(bonds, leadVector);
            
            if offset <= 5 && twistAngles(1) ~= phi0 && twistAngles(end) ~= phi0
            
                angleList = [ angleList ; twistAngles ]; %#ok<AGROW>
                printAngles(offset, twistAngles)
                
                plotBonds([], bonds, phi, phi0);
                hold on
                
                plot3(leadBond(1, :), leadBond(2, :), leadBond(3, :), 'y-', 'linewidth', 4);
                
                plot3(tailBond(1, :), tailBond(2, :), tailBond(3, :), 'y-', 'linewidth', 4);
                
                plot3(middleBond(1, :), middleBond(2, :), middleBond(3, :), 'g-', 'linewidth', 4);
                
                titleLine = 'Phi: [ ';
                for j = 1:numTwists
                    titleLine = [ titleLine sprintf('%.1f ', twistAngles(j)) ]; %#ok<AGROW>
                end
                titleLine = [ titleLine ']' ]; %#ok<AGROW>
                title({ sprintf('Offset = %.2f', offset) ; titleLine })
                
                pause
                close(gcf)
            
            end
                
        end
        
    end
    
    if ~isempty(angleList)
        
        saveFile = sprintf('../Data/Spiral-%d-%dx%d', round(theta0), round(phi0), length(twistLinks));
        save(saveFile, 'angleList', 'N', 'theta0', 'phi0', 'twistLinks')
        
        [ rows, ~ ] = size(angleList);
        fprintf('Found %d spiral(s) for (theta, phi) = (%d, %d), links %d:%d\n', ...
            rows, theta0, phi0, twistLinks(1), twistLinks(end))
        
    else
        
        fprintf('Didn''t find any spirals for (theta, phi) = (%d, %d), links %d:%d\n', ...
            theta0, phi0, twistLinks(1), twistLinks(end))
        
    end
    
    function angles = findAngles
        
        angles = [];
        
        if count == 0
            
            angles = ones(1, numTwists);
            count = 1;
            
        elseif count < numTries
            
            numerator = count;
            
            while numerator ~= 0
                
                remainder = rem(numerator, numAngles);
                angles = [  angles remainder+1 ]; %#ok<AGROW>
                
                numerator = floor(numerator/numAngles);
                
            end
            
            if length(angles) < numTwists
                
                angles = [ angles ones(1, numTwists-length(angles)) ];
                
            end
            
            count = count + 1;
            
        end
        
    end
    
    function printAngles(offset, twistAngles)
        
        theString = sprintf('offset = %.2f, angles = [', max(offset));
        
        for index = 1: length(twistAngles)
            
            theString = sprintf('%s %.2f', theString, twistAngles(index));
            
        end
        
        theString = [ theString ' ]' ];
        
        disp(theString)
        
    end
    
    function value = isEven(argument)
        
        value = mod(argument, 2) == 0;
        
    end
    
end
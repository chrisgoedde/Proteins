function findSpiral(theta0, phi0, numTwists, angleCutoff, offsetCutoff)
    
    N = 30;
    l = 1;
    theta = theta0 * ones(1, N);
    
    firstTwist = N/2 - floor(numTwists/2)+1;
    twistLinks = firstTwist:(firstTwist+numTwists-1);
    
    count = 0;
    
    numAngles = 3;
    angleSet = linspace(0, 360, numAngles+1) + phi0;
    angleSet = angleSet(1:end-1);
    
    phi = phi0 * ones(1, N);
    
    regularBonds = findBonds(N, l, theta, phi);
    regularExtent = findExtent(regularBonds);
    
    numTries = numAngles^numTwists;
    angleList = [];
    
    for i = 1:numTries
        
        if ~mod(i, 10000)
            
            fprintf('Starting attempt %d of %d\n', i, numTries)
            
        end
        
        twistIndices = findAngles;
        
        twistAngles = angleSet(twistIndices);
        
        phi(twistLinks) = twistAngles;
        
        bonds = findBonds(N, l, theta, phi);
        
        [ ~, ~, ~, alignment, offset ] = findAlignment(bonds, twistLinks);
        extent = findExtent(bonds);
        shrinkage = regularExtent - extent;
        
        % fprintf('alignment = %.2f\n', alignment)
        
        if abs(alignment) > cos(angleCutoff * pi/180)
            
            numTwists = length(twistLinks);
            
            if offset <= offsetCutoff && twistAngles(1) ~= phi0 && twistAngles(end) ~= phi0
            
                angleList = [ angleList ; twistAngles ]; %#ok<AGROW>
                printAngles(alignment, offset, shrinkage, twistAngles)
                
                %{
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
                %}
            
            end
                
        end
        
    end
    
    if ~isempty(angleList)
        
        saveFolder = sprintf('../Data/angle = %d/radius = %.1f', angleCutoff, offsetCutoff);
        if ~exist(saveFolder, 'dir')
            
            mkdir(saveFolder)
            
        end
        saveFile = sprintf('%s/Spiral-%d-%dx%d', saveFolder, round(theta0), round(phi0), length(twistLinks));
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
    
    function printAngles(alignment, offset, shrinkage, twistAngles)
        
        theString = sprintf('alignment = %.2f degrees, radius = %.2f, shrinkage = %.2f, angles = [', ...
            180*acos(alignment)/pi, max(offset), shrinkage);
        
        for index = 1: length(twistAngles)
            
            theString = sprintf('%s %.2f', theString, twistAngles(index));
            
        end
        
        theString = [ theString ' ]' ];
        
        disp(theString)
        
    end
    
end
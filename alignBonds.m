function alignBonds(theta, twistLinks)
    
    N = 20;
    l = 1;
    theta = theta*pi/180;
    phi = zeros(1, N);
    
    numTwists = length(twistLinks);
    
    count = 0;
    
    numAngles = 60;
    angleSet = linspace(-pi, pi, numAngles+1);
    angleSet = angleSet(1:end-1);
    
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
        
        middleBond = [ bonds{twistLinks(1)+1}(:,1) bonds{twistLinks(end)+1}(:,2) ];
        
        if isEven(N-twistLinks(end))
            
            tailBond = [ bonds{twistLinks(end)+1}(:,2) bonds{end-1}(:,2) ];
            
        else
            
            tailBond = [ bonds{twistLinks(end)+1}(:,2) bonds{end}(:,2) ];
            
        end
        
        leadVector = leadBond(:,2) - leadBond(:,1);
        tailVector = tailBond(:,2) - tailBond(:,1);
        middleVector = middleBond(:,2) - middleBond(:,1);
        
        alignment = (leadVector' * tailVector)/(norm(leadVector)*norm(tailVector));
        
        % fprintf('alignment = %.2f\n', alignment)
        
        if abs(1-alignment) < 0.0001
            
            offset = norm(cross(middleVector, leadVector))/norm(leadVector);
            
            printAngles(offset, twistAngles)
            
            if offset < 0.5
                
                angleList = [ angleList ; twistAngles ]; %#ok<AGROW>
                
                %{
                plotBonds([], bonds, phi);
                hold on
                
                plot3(leadBond(1, :), leadBond(2, :), leadBond(3, :), 'y-', 'linewidth', 4);
                
                plot3(tailBond(1, :), tailBond(2, :), tailBond(3, :), 'y-', 'linewidth', 4);
                
                plot3(middleBond(1, :), middleBond(2, :), middleBond(3, :), 'g-', 'linewidth', 4);
                
                titleLine = 'Phi: [ ';
                for j = 1:numTwists
                    titleLine = [ titleLine sprintf('%.1f ', twistAngles(j)*180/pi) ]; %#ok<AGROW>
                end
                titleLine = [ titleLine ']' ]; %#ok<AGROW>
                title(titleLine)
                
                pause
                close(gcf)
                %}
                
            end
            
        end
        
    end
    
    saveFile = sprintf('../Data/Angles-%dx%d', round(theta*180/pi), length(twistLinks));
    save(saveFile, 'angleList')
    
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
        
        theString = sprintf('offset = %.2f, angles = [', offset);
        
        for index = 1: length(twistAngles)
            
            theString = sprintf('%s %.2f', theString, twistAngles(index)*180/pi);
            
        end
        
        theString = [ theString ' ]' ];
        
        disp(theString)
        
    end
    
    function value = isEven(argument)
        
        value = mod(argument, 2) == 0;
        
    end
    
end
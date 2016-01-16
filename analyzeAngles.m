function analyzeAngles(angleFile)
    
    angleList = [];
    saveFile = sprintf('../Data/%s', angleFile);
    load(saveFile);
    
    [ numAngles, numTwists ] = size(angleList);

    fprintf('Analyzing %d sets of angles from file %s.mat.\n', numAngles, angleFile)
    
    for i = 1:numAngles
        
        if sum(angleList(i, :) >= 0) == numTwists
            
            printAngles(angleList(i, :))
            
        elseif sum(angleList(i, :) <= 0) == numTwists
            
            % printAngles(angleList(i, :))
            
        end
        
        count = 0;
        
        while angleList(i, count+1) == -angleList(i, numTwists-count)
            
            count = count + 1;
            
            if count > floor(numTwists/2)
                
                % printAngles(angleList(i, :))
                               
                break
                
            end
            
        end
        
    end
    
    function printAngles(angles)
        
        fprintf('Set %d angles: [', i)
        
        for index = 1:numTwists
            
            fprintf(' %.0f', angles(index)*180/pi);
            
        end
        
        fprintf(' ], Sum = %.0f\n', sum(angles*180/pi))
        
    end
        
end
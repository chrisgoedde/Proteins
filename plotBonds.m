function thePlot = plotBonds(thePlot, bonds, phi)
    
    linesMap = lines;
    theColor = cell(1, length(bonds)+1);
    theColor{1} = linesMap(1,:);
    
    for i = 1:length(bonds)
        
        if phi(i) == 0
            
            theColor{i+1} = linesMap(1,:);
            
        else
            
            theColor{i+1} = linesMap(2,:);
            
        end
        
    end
    
    if isempty(thePlot)
        
        hold on
        
        for i = length(bonds):-1:1
            
            p = plot3(bonds{i}(1, 1:2), bonds{i}(2, 1:2), bonds{i}(3, 1:2), ...
                '-', 'linewidth', 2, 'color', theColor{i});
            
            midpoint = (bonds{i}(:, 3) + bonds{i}(:, 4))/2 ...
                + (bonds{i}(:, 2) - bonds{i}(:, 1))/2;
            X = [ bonds{i}(1, 1:2) midpoint(1) ];
            Y = [ bonds{i}(2, 1:2) midpoint(2) ];
            Z = [ bonds{i}(3, 1:2) midpoint(3) ];
            h = fill3(X, Y, Z, theColor{i}, 'edgecolor', 'none', ...
                'facealpha', 0.5);
            
            thePlot{i} = { p h };
            
        end
        
        grid on, axis equal
        set(gca, 'fontsize', 14)
        % set(gca, 'zlim', [ -1 1 ])
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        
    else
        
        for i = 1:length(bonds)
            
            delete(thePlot{i}{2})
            set(thePlot{i}{1}, 'xdata', bonds{i}(1, 1:2), 'ydata', bonds{i}(2, 1:2), ...
                'zdata', bonds{i}(3, 1:2), 'color', theColor{i})
            
            midpoint = (bonds{i}(:, 3) + bonds{i}(:, 4))/2 ...
                + (bonds{i}(:, 2) - bonds{i}(:, 1))/2;
            X = [ bonds{i}(1, 1:2) midpoint(1) ];
            Y = [ bonds{i}(2, 1:2) midpoint(2) ];
            Z = [ bonds{i}(3, 1:2) midpoint(3) ];
            thePlot{i}{2} = fill3(X, Y, Z, theColor{i}, 'edgecolor', 'none', ...
                'facealpha', 0.5);
            
        end
        shg
        
    end
    
end


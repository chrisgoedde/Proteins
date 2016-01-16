function p = plotBonds(thePlot, bonds, phi)
    
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
            
            p{i} = plot3(bonds{i}(1, :), bonds{i}(2, :), bonds{i}(3, :), ...
                '-s', 'linewidth', 4, 'markersize', 8, 'color', theColor{i}, ...
                'markerfacecolor', theColor{i} );
            
        end
        
        grid on, axis equal
        set(gca, 'fontsize', 14)
        % set(gca, 'zlim', [ -1 1 ])
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        
    else
        
        for i = 1:length(bonds)
            
            disp(theColor{i})
            
            set(thePlot{i}, 'xdata', bonds{i}(1, :), 'ydata', bonds{i}(2, :), ...
                'zdata', bonds{i}(3, :), 'color', theColor{i}, ...
                'markerfacecolor', theColor{i})
            
        end
        shg
        
    end
    
end


function bonds = findBonds(N, l, theta, phi)
    
    % Calculate the bond vectors based on a given set of bond angles. The
    % input parameters are:
    % N = number of bonds
    % l = length of each bond
    % theta = a fixed bond angle, the same for each bond
    % phi a row vector containing the N values of the angle phi for all the
    % bonds
    
    T = eye(3);
    
    head = [ l ; 0 ; 0 ];
    
    % bonds will be a 1xN cell array holding N 3x2 matrices to describe the
    % N bond vectors. The very first bond is chosen to lie along the x
    % axis.
    
    bonds = cell(1, N);
    bonds{1} = [ [ 0 ; 0 ; 0 ] head ];
    
    for i = 2:N
        
        T = T * transform(theta, phi(i-1));
        newHead = head + T * [ l ; 0 ; 0 ];
        bonds{i} = [ head newHead ];
        head = newHead;
        
    end
    
    function T = transform(theta, phi)
        
        T = zeros(3);
        T(1, 1) = cos(theta);
        T(1, 2) = sin(theta);
        T(2, 1) = sin(theta)*cos(phi);
        T(2, 2) = -cos(theta)*cos(phi);
        T(2, 3) = sin(phi);
        T(3, 1) = sin(theta)*sin(phi);
        T(3, 2) = -cos(theta)*sin(phi);
        T(3, 3) = -cos(phi);
        
    end
    
end


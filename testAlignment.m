function result = testAlignment(x, N, l, theta0, phi0, phid, numTwists)
    
    firstTwist = N/2 - floor(numTwists/2)+1;
    twistLinks = firstTwist:(firstTwist+numTwists-1);
    
    theta = theta0 * ones(1, N);
    phi = phi0 + ones(1, N);
    phi(firstTwist-1) = phid;
    phi(twistLinks) = x;
    
    bonds = findBonds(N, l, theta, phi);
    [ ~, ~, ~, alignment, radius ] = findAlignment(bonds, twistLinks);
    
    result = 1-alignment +radius;
    
end
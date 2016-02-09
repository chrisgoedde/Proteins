function runSpiral(theta, phi)
    
    start = 11;
    
    for N = 2:9
    
        findSpiral(theta, phi, start:start+N)
        
    end
    
end

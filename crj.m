function [c] = crj(r,j,k)

div = 0;
for m = j + 1 : k
    
    soma1 = 0;
    for l = 0 : k 
        if l~= m
            prod1 = 1;
            for q = 0 : k
                if (q ~= m) && (q ~= l)                    
                    prod1 = prod1 * (r-q+1);
                end
            end
            soma1 = prod1 + soma1;                            
        end        
    end
    
    prod2 = 1;
    for l = 0 : k
        if l ~= m
            prod2 = prod2 * (m-l); 
        end        
    end
    
    div = soma1/prod2 + div;  
    
end
c = div;
end
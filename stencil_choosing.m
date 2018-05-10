function [S]=stencil_choosing(f, inp)

xl=inp.TOTAL_POINTS;
xr=xl;

p_xl=xl-1;
n_xr=xr+1;

for j=1:inp.N_N_POINTS

    %Left
    V_u_p = undivided_differences_2(f,p_xl,xr,inp.TABLE);

    
    %Right
    V_u_n = undivided_differences_2(f,xl,n_xr,inp.TABLE);

    
    if abs(V_u_p)<=abs(V_u_n)
        
        xl=xl-1;
        p_xl=p_xl-1;
        
    else
        
        xr=xr+1;
        n_xr=xr+1;
    end
    
end

S=[xl xr];

end



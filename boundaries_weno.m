function [vhr, vhl] =boundaries_weno (p, x, inp)

vhr=zeros(inp.SIZEX,1);
vhl=vhr;

vhr_dummy=zeros(inp.N_N_POINTS+1,1);
vhl_dummy=vhr_dummy;

for k=inp.V1:inp.VN
    
    f(:,1)=p(k-inp.N_N_POINTS : k+inp.N_N_POINTS);
    
    y=x(k-inp.N_N_POINTS : k+inp.N_N_POINTS);

    xhr=x(k)+inp.DELTA_X*0.5;
    xhl=x(k)-inp.DELTA_X*0.5;
    
    df=f(inp.TOTAL_POINTS+1)-f(inp.TOTAL_POINTS);
    for l=1:inp.TOTAL_POINTS       
        
        S=[l l+inp.N_N_POINTS];
        
        %Calculo de v- +1/2  
            r = inp.TOTAL_POINTS - S(1) + 2;
            vhr_dummy(l) = inp.CRJ(r,:)*f(S(1):S(2));
            
        %Calculo de v+ -1/2
            vhl_dummy(l) = inp.CRJ(r-1,:)*f(S(1):S(2));


    end
    
    
    if df>0
        s=1;
    else
        s=2;
    end
    
%     beta=smooth_factor(f, inp);
    
    beta = analitical_smooth_factor(f,inp.TOTAL_POINTS);
    
    if inp.TOTAL_POINTS == 2
       C = [1/3 ; 2/3]; 
       C_l = [2/3 1/3];
    end
    
    if inp.TOTAL_POINTS == 3
       C = [1/10 ; 3/5 ; 3/10]; 
       C_l = [3/10 ; 3/5 ; 1/10]; 
    end
    alpha=C./((inp.EPSILON+beta).^2);
    alpha_l=C_l./((inp.EPSILON+beta).^2);
    
    w=alpha./sum(alpha);
    w_l=alpha_l./sum(alpha_l);
    
    
    for m=1:inp.TOTAL_POINTS
        vhr(k)=vhr(k)+w(m)*vhr_dummy(m);
        vhl(k)=vhl(k)+w_l(m)*vhl_dummy(m);
    end
            
end

%Condicoes de contorno

for i=1:inp.V1-1
    
    vhr(i)=f_ce('l',inp.CCL,vhr(inp.V1+1:inp.V1+1+inp.EC/2),vhr(inp.VN-inp.EC/2:inp.VN),i);
    vhr(i+inp.VN)=f_ce('r',inp.CCR,vhr(inp.V1+1:inp.V1+1+inp.EC/2),vhr(inp.VN-inp.EC/2:inp.VN),i);
   
    vhl(i)=f_ce('l',inp.CCL,vhl(inp.V1+1:inp.V1+1+inp.EC/2),vhl(inp.VN-inp.EC/2:inp.VN),i);
    vhl(i+inp.VN)=f_ce('r',inp.CCR,vhl(inp.V1+1:inp.V1+1+inp.EC/2),vhl(inp.VN-inp.EC/2:inp.VN),i);
end



end

function [beta] = analitical_smooth_factor(f,s)
    if s == 2
        beta=[ (f(2)-f(1))^2 (f(3)-f(2))^2 ];
    end
        
    if s == 3
        beta = [ 13/12*(f(1)-2*f(2)+f(3))^2+1/4*(f(1)-4*f(2)+3*f(3))^2 ;...
                 13/12*(f(2)-2*f(3)+f(4))^2+1/4*(f(2)-f(4))^2 ;...
                 13/12*(f(3)-2*f(4)+f(5))^2+1/4*(3*f(3)-4*f(4)+f(5))^2];
    end
end

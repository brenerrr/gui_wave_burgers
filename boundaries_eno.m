function [vhr, vhl] =boundaries_eno (p, x, inp)


vhr=zeros(inp.SIZEX,1);
vhl=vhr;

for k=inp.V1:inp.VN
    
    f(:,1)=p(k-inp.N_N_POINTS : k+inp.N_N_POINTS);
    
    y=x(k-inp.N_N_POINTS : k+inp.N_N_POINTS);
    
    %Escolha do stencil
    
    S=stencil_choosing(f, inp);

    %Calculo de v- +1/2
%     xhr=x(k)+inp.DELTA_X/2;
%     vhr(k)=poli(S, xhr , inp.N_N_POINTS , f, y, inp.DELTA_X, inp.TABLE);
    r = inp.TOTAL_POINTS - S(1) + 2;
    vhr(k) = ( inp.CRJ(r,:)*f(S(1):S(2)));
    
    %Calculo de v+ -1/2
%     xhl=x(k)-inp.DELTA_X/2;
%     vhl(k)=poli(S, xhl , inp.N_N_POINTS , f, y, inp.DELTA_X, inp.TABLE);
    vhl(k) = ( inp.CRJ(r-1,:)*f(S(1):S(2)));
    
end

%Condicoes de contorno

for i=1:inp.V1-1
    
    vhr(i)=f_ce('l',inp.CCL,vhr(inp.V1+1:inp.V1+1+inp.EC/2),vhr(inp.VN-inp.EC/2:inp.VN),i);
    vhr(i+inp.VN)=f_ce('r',inp.CCR,vhr(inp.V1+1:inp.V1+1+inp.EC/2),vhr(inp.VN-inp.EC/2:inp.VN),i);
   
    vhl(i)=f_ce('l',inp.CCL,vhl(inp.V1+1:inp.V1+1+inp.EC/2),vhl(inp.VN-inp.EC/2:inp.VN),i);
    vhl(i+inp.VN)=f_ce('r',inp.CCR,vhl(inp.V1+1:inp.V1+1+inp.EC/2),vhl(inp.VN-inp.EC/2:inp.VN),i);
end


end


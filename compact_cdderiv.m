function [df] = compact_cdderiv(f, inp)

a1=-1/36;
a2=-7/9;
% a3=0;
a4=-a2;
a5=-a1;


B=(a1*f(inp.V1-2:inp.VN-2)+a2*f(inp.V1-1:inp.VN-1)+a4*f(inp.V1+1:inp.VN+1)+a5*f(inp.V1+2:inp.VN+2))*1/inp.DELTA_X;
A=pentadiagonal(0,1/3,1,1/3,0,inp.SIZEX-inp.EC);

A(1,:)=f_ce_compact('l',inp.CCL,inp.SIZEX-inp.EC);
A(end,:)=f_ce_compact('r',inp.CCR,inp.SIZEX-inp.EC);

df=linsolve(A,B);

end


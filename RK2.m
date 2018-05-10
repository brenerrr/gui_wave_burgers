function [ff]=RK2(p, x, inp)

f1=zeros(inp.SIZEX,1);
ff=f1;  

df_dt=F(p, x, inp);

% First step
f1(inp.V1:inp.VN)=p(inp.V1:inp.VN) + 1*inp.DELTA_T*df_dt;

% Boundary condition
for i=1:inp.V1-1
    f1(i)=f_ce('l',inp.CCL,f1(inp.V1+1:inp.V1+1+inp.EC/2),f1(inp.VN-inp.EC/2:inp.VN),i);
    f1(i+inp.VN)=f_ce('r',inp.CCR,f1(inp.V1+1:inp.V1+1+inp.EC/2),f1(inp.VN-inp.EC/2:inp.VN),i);
end

df1_dt=F(f1, x, inp);
% Second step
ff(inp.V1:inp.VN)=(p(inp.V1:inp.VN)+f1(inp.V1:inp.VN))*0.5+0.5*inp.DELTA_T*df1_dt;

for i=1:inp.V1-1
    ff(i)=f_ce('l',inp.CCL,ff(inp.V1+1:inp.V1+1+inp.EC/2),ff(inp.VN-inp.EC/2:inp.VN),i);
    ff(i+inp.VN)=f_ce('r',inp.CCR,ff(inp.V1+1:inp.V1+1+inp.EC/2),ff(inp.VN-inp.EC/2:inp.VN),i);
end

end
function [ff]=RK4(p, x, inp)

% global SIZEX DELTA_T EC V1 VN CCL CCR
% f1=ones(inp.SIZEX,1);
% f2=f1;
% f3=f1;
% ff=f1;
% 
% 
% df_dt=F(p, x, inp);
% 
% f1(inp.V1:inp.VN)=p(inp.V1:inp.VN)+0.5*inp.DELTA_T*df_dt;
% for i=1:inp.V1-1
%     f1(i)=f_ce('l',inp.CCL,f1(inp.V1+1:inp.V1+1+inp.EC/2),f1(inp.VN-inp.EC/2:inp.VN),i);
%     f1(i+inp.VN)=f_ce('r',inp.CCR,f1(inp.V1+1:inp.V1+1+inp.EC/2),f1(inp.VN-inp.EC/2:inp.VN),i);
% end
% df1_dt=F(f1, x, inp);
% 
% f2(inp.V1:inp.VN)=p(inp.V1:inp.VN)+0.5*inp.DELTA_T*df1_dt;
% for i=1:inp.V1-1
%     f2(i)=f_ce('l',inp.CCL,f2(inp.V1+1:inp.V1+1+inp.EC/2),f2(inp.VN-inp.EC/2:inp.VN),i);
%     f2(i+inp.VN)=f_ce('r',inp.CCR,f2(inp.V1+1:inp.V1+1+inp.EC/2),f2(inp.VN-inp.EC/2:inp.VN),i);
% end
% df2_dt=F(f2, x, inp);
% 
% f3(inp.V1:inp.VN)=p(inp.V1:inp.VN)+inp.DELTA_T*df2_dt;
% for i=1:inp.V1-1
%     f3(i)=f_ce('l',inp.CCL,f3(inp.V1+1:inp.V1+1+inp.EC/2),f3(inp.VN-inp.EC/2:inp.VN),i);
%     f3(i+inp.VN)=f_ce('r',inp.CCR,f3(inp.V1+1:inp.V1+1+inp.EC/2),f3(inp.VN-inp.EC/2:inp.VN),i);
% end
% df3_dt=F(f3, x, inp);
% 
% ff(inp.V1:inp.VN)=p(inp.V1:inp.VN)+1/6*inp.DELTA_T*(df_dt+2*(df1_dt+df2_dt)+df3_dt);
% for i=1:inp.V1-1
%     ff(i)=f_ce('l',inp.CCL,ff(inp.V1+1:inp.V1+1+inp.EC/2),ff(inp.VN-inp.EC/2:inp.VN),i);
%     ff(i+inp.VN)=f_ce('r',inp.CCR,ff(inp.V1+1:inp.V1+1+inp.EC/2),ff(inp.VN-inp.EC/2:inp.VN),i);
% end

A = [ 0, -6234157559845.0D0/12983515589748.0D0, ...
     -6194124222391.0D0/4410992767914.0D0, ...
     -31623096876824.0D0/15682348800105.0D0, ...
     -12251185447671.0D0/11596622555746.0D0]; 
 
B = [ 494393426753.0D0/4806282396855.0D0, ...
      4047970641027.0D0/5463924506627.0D0, ...
      9795748752853.0D0/13190207949281.0D0, ...
      4009051133189.0D0/8539092990294.0D0, ...
      1348533437543.0D0/7166442652324.0D0];
  
f1=ones(inp.SIZEX,1);
f2=f1;
f3=f1;
ff=f1;


df_dt=F(p, x, inp);

q = inp.DELTA_T*df_dt;
f1(inp.V1:inp.VN)=p(inp.V1:inp.VN)+B(1)*q;

for i=1:inp.V1-1
    f1(i)=f_ce('l',inp.CCL,f1(inp.V1+1:inp.V1+1+inp.EC/2),f1(inp.VN-inp.EC/2:inp.VN),i);
    f1(i+inp.VN)=f_ce('r',inp.CCR,f1(inp.V1+1:inp.V1+1+inp.EC/2),f1(inp.VN-inp.EC/2:inp.VN),i);
end

df1_dt=F(f1, x, inp);

q = inp.DELTA_T*df1_dt + A(2)*q;
f2(inp.V1:inp.VN)=f1(inp.V1:inp.VN)+B(2)*q;

for i=1:inp.V1-1
    f2(i)=f_ce('l',inp.CCL,f2(inp.V1+1:inp.V1+1+inp.EC/2),f2(inp.VN-inp.EC/2:inp.VN),i);
    f2(i+inp.VN)=f_ce('r',inp.CCR,f2(inp.V1+1:inp.V1+1+inp.EC/2),f2(inp.VN-inp.EC/2:inp.VN),i);
end
df2_dt=F(f2, x, inp);

q = inp.DELTA_T*df2_dt + A(3)*q;
f3(inp.V1:inp.VN)=f2(inp.V1:inp.VN)+B(3)*q;

for i=1:inp.V1-1
    f3(i)=f_ce('l',inp.CCL,f3(inp.V1+1:inp.V1+1+inp.EC/2),f3(inp.VN-inp.EC/2:inp.VN),i);
    f3(i+inp.VN)=f_ce('r',inp.CCR,f3(inp.V1+1:inp.V1+1+inp.EC/2),f3(inp.VN-inp.EC/2:inp.VN),i);
end

df3_dt=F(f3, x, inp);

q = inp.DELTA_T*df3_dt + A(4)*q;
f3(inp.V1:inp.VN)=f3(inp.V1:inp.VN)+ B(4)*q;

for i=1:inp.V1-1
    f3(i)=f_ce('l',inp.CCL,f3(inp.V1+1:inp.V1+1+inp.EC/2),f3(inp.VN-inp.EC/2:inp.VN),i);
    f3(i+inp.VN)=f_ce('r',inp.CCR,f3(inp.V1+1:inp.V1+1+inp.EC/2),f3(inp.VN-inp.EC/2:inp.VN),i);
end

df3_dt=F(f3, x, inp);
q = inp.DELTA_T*df3_dt + A(5)*q;

ff(inp.V1:inp.VN)=f3(inp.V1:inp.VN)+ B(5)*q;

for i=1:inp.V1-1
    ff(i)=f_ce('l',inp.CCL,ff(inp.V1+1:inp.V1+1+inp.EC/2),ff(inp.VN-inp.EC/2:inp.VN),i);
    ff(i+inp.VN)=f_ce('r',inp.CCR,ff(inp.V1+1:inp.V1+1+inp.EC/2),ff(inp.VN-inp.EC/2:inp.VN),i);
end

end

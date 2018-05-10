function [beta]=smooth_factor(f, inp)
 
r=inp.TOTAL_POINTS;
j=r;
beta=zeros(j,1);
 
 for w=1:r
     
     for l=1:r-1
         
         b=0;
         
         for k=1:l
             xl=j-r+k;
             xr=j-l+k;
             b=b+undivided_differences_2(f, xl, xr, inp.TABLE)^2;
         end
         b=b/l;
         
         beta(w)=beta(w)+b;
         
     end
     
     j=j+1;

 end



% 
% u=[1 2 1 3 2 ];
% 
% size_u=length(u);
% SIZE_V=size_u;
% 
%  V_u=zeros(SIZE_V,SIZE_V);
%  flag_u=zeros(SIZE_V,SIZE_V);
%  
%  for j=1:SIZE_V
%      V_u(j,j)=u(j);
%      flag_u(j,j)=1;
%  end
% 
%  
%  j=3+1;
%  r=3;
%  beta=0;
% for l=1:r-1
%     
%     b=0;
%     
%    for k=1:l
%       xl=j-r+k;
%       xr=j-l+k;
%       b=b+undivided_differences(0,V_u,xl,xr,flag_u)^2;     
%    end
%    b=b/l;
%     
%    beta=beta+b;
%    
% end
% 
% beta_teorico=((u(j-1)-u(j-2))^2+(u(j)-u(j-1))^2)/2+(u(j)-2*u(j-1)+u(j-2))^2;
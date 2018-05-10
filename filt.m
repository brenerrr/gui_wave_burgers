function [f_til]=filt(f,k,a,b,c,d,coef,B,V1f,VNf, inp)

% global V1 VN FILTER CCL CCR EC SIZEX

% f_til=zeros(SIZEX,1);
% 
%     if periodic==1
%         B(1)=a*f(V1) + b/2*(f(VN)+f(V1+1)) + c/2*(f(VN-1)+f(V1+2)) + d/2*(f(VN-2)+f(V1+3));
%         B(2)=a*f(V1+1) + b/2*(f(V1)+f(V1+2)) + c/2*(f(VN)+f(V1+3)) + d/2*(f(VN-1)+f(V1+4));
%         B(3)=a*f(V1+2) + b/2*(f(V1+1)+f(V1+3)) + c/2*(f(V1)+f(V1+4)) + d/2*(f(VN)+f(V1+5));
%         
%         B(k)=a*f(VN) + b/2*(f(VN-1)+f(V1)) + c/2*(f(VN-2)+f(V1+1)) + d/2*(f(VN-3)+f(V1+2));
%         B(k-1)=a*f(VN-1) + b/2*(f(VN-2)+f(VN)) + c/2*(f(VN-3)+f(V1)) + d/2*(f(VN-4)+f(V1+1));
%         B(k-2)=a*f(VN-2) + b/2*(f(VN-3)+f(VN-1)) + c/2*(f(VN-4)+f(VN))+d/2*(f(VN-5)+f(V1));
%     end
%         
%     B(4:k-3)=a*f(V1+3:VN-3) + b/2*(f(V1+2:VN-4)+f(V1+4:VN-2))+ ...
%         c/2*(f(V1+1:VN-5)+f(V1+5:VN-1)) + d/2*(f(V1:VN-6)+f(V1+6:VN));    
% 

dummy=zeros(k+inp.FILTER,1);
dummy(V1f:VNf)=f;

for i=1:V1f-1
    dummy(i)=f_ce('l',inp.CCL,dummy(V1f:V1f+1+inp.FILTER/2),dummy(VNf-inp.FILTER/2+1:VNf+1),i);
    dummy(i+VNf)=f_ce('r',inp.CCR,dummy(V1f:V1f+inp.FILTER/2),dummy(VNf-inp.FILTER/2:VNf),i);
end

%     for i=1:V1f-1
%     dummy(i)=f_ce('l',CCL,dummy(V1f+1:V1f+1+FILTER/2),dummy(VNf-FILTER/2+1:VNf+1),i);
%     dummy(i+VNf)=f_ce('r',CCR,dummy(V1f:V1f+FILTER/2),dummy(VNf-FILTER/2:VNf),i);
% end


if inp.FILTER ==6
    B=a*dummy(V1f:VNf) + b/2*(dummy(V1f-1:VNf-1)+dummy(V1f+1:VNf+1))+ ...
        c/2*(dummy(V1f-2:VNf-2)+dummy(V1f+2:VNf+2)) + d/2*(dummy(V1f-3:VNf-3)+dummy(V1f+3:VNf+3));
end

if inp.FILTER ==4
    B=a*dummy(V1f:VNf) + b/2*(dummy(V1f-1:VNf-1)+dummy(V1f+1:VNf+1))+ ...
        c/2*(dummy(V1f-2:VNf-2)+dummy(V1f+2:VNf+2));
end

 
% 
%     
%     
%   
% f_til=zeros(SIZEX-EC,1);
%     f_til(4:end-3)=linsolve(coef(4:end-3,4:end-3),B(4:end-3));

f_til=linsolve(coef,B);
% if CCL~=1
    f_til(1)=15/16*f(1)+1/16*(4*f(2)-6*f(3)+4*f(4)-f(5));
    f_til(2)=3/4*f(2)+1/16*(f(1)+6*f(3)-4*f(4)+f(5));
    f_til(3)=5/8*f(3)+1/16*(-f(1)+4*f(2)+4*f(4)-f(5));
% end
% if CCR~=1
    f_til(end)=15/16*f(end)+1/16*(4*f(end-1)-6*f(end-2)+4*f(end-3)-f(end-4));
    f_til(end-1)=3/4*f(end-1)+1/16*(f(end)+6*f(end-2)-4*f(end-3)+f(end-4));
    f_til(end-2)=5/8*f(end-2)+1/16*(-f(end)+4*f(end-1)+4*f(end-3)-f(end-4));
% end
%     f_til(1)=f(1);
%     f_til(end)=f(end);
    
%     plot(f,'g')
%     pause(2)
%     
%     plot(dummy)
%     pause(2)
%     plot(B,'r')
%     pause(2)    
%     plot(f_til,'k')
%     pause(2)
%     
%     f_til(V1:VN)=linsolve(coef,B);
%     plot(f_til(V1:VN),'k');
%     for i=1:V1-1
%         f_til(i)=f_ce('l',CCL,f_til(V1+1:V1+1+EC/2),f_til(VN-EC/2:VN),i);
%         f_til(i+VN)=f_ce('r',CCR,f_til(V1+1:V1+1+EC/2),f_til(VN-EC/2:VN),i);
%     end
    
end


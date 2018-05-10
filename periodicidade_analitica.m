function [x, f] = periodicidade_analitica(f,x,infx,supx,sizex)

flag=0;
for i=1:sizex
    if x(i)>supx

        flag=i;
        
        dummyx = x(flag:end);
        dummyf = f(flag:end);
        
        x(end-flag+2:end)=x(1:flag-1);
        f(end-flag+2:end)=f(1:flag-1);
        
        x(1:end-flag+1)=dummyx-supx+infx;
        f(1:end-flag+1)=dummyf;
        
        i=sizex+1;
    end
end
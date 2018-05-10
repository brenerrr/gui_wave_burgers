function [result] = undivided_differences_2 (f,xl,xr,table)

i=xr-xl+1;
result=table(i,1:i)*f(xl:xr);

end
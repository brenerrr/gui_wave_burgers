function [A]=pentadiagonal(a1,a2,a3,a4,a5,size)

A=zeros(size,size);

for n=1:size
    ind=0;
    if n==1    
        A(n,n)=a3;
        A(n,n+1)=a4;
        A(n,n+2)=a5;
        ind=1;
    end
    
    if n==2        
        A(n,n-1)=a2;
        A(n,n)=a3;
        A(n,n+1)=a4;
        A(n,n+2)=a5;
        ind=1;
    end
    
    if n==size-1
        A(n,n-2)=a1;
        A(n,n-1)=a2;
        A(n,n)=a3;
        A(n,n+1)=a4;
        ind=1;
    end
    
    if n==size
        A(n,n-2)=a1;
        A(n,n-1)=a2;    
        A(n,n)=a3;
        ind=1;
    end
    
    if ind==0    
    A(n,n-2)=a1;
    A(n,n-1)=a2;
    A(n,n)=a3;
    A(n,n+1)=a4;
    A(n,n+2)=a5;
    end
    
    
    
end

end
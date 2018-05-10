function [C]=coefficients_weno (r)

a=zeros(r,2);
C=zeros(r,2);
np=zeros(r,2);
nn=zeros(r,2);


%Derivada positiva (1)
x=0.5;
for k=0:r-1
    
    for s=0:r
        
        prod=1;
        
        for l=0:r
            
            if l~=s
                prod=prod*((x)-(k-l+0.5));
                
            end
            
        end
        
        a(k+1,1)=a(k+1,1)+prod;
        
    end    
    
    if a(k+1,1)>0 
        np(1)=np(1)+1;
    end
    
    if a(k+1,1)<0
        nn(1)=nn(1)+1;        
    end
    
end

for k=0:r-1
   
    if a(k+1,1)==0
        C(k+1,1)=1;
    end
    
    if a(k+1,1)>0
        C(k+1,1)=1./(np(1)*a(k+1,1));
    end
    
    if a(k+1,1)<0
        C(k+1,1)=1./(nn(1)*a(k+1,1));
    end
    
end


%Derivada negativa (2)
x=-0.5;
for k=0:r-1
    
    for s=0:r
        
        prod=1;
        
        for l=0:r
            
            if l~=s
                prod=prod*((x)-(k-l+0.5));
                
            end
            
        end
        
        a(k+1,2)=a(k+1,2)+prod;
        
    end
    
    if a(k+1,2)>0 
        np(2)=np(2)+1;
    end
    
    if a(k+1,2)<0
        nn(2)=nn(2)+1;        
    end
    
end

for k=0:r-1
   
    if a(k+1,2)==0
        C(k+1,2)=1;
    end
    
    if a(k+1,2)>0
        C(k+1,2)=1./(np(2)*a(k+1,2));
    end
    
    if a(k+1,2)<0
        C(k+1,2)=1./(nn(2)*a(k+1,2));
    end
    
end

%**************************************************************************

C=abs(C);


end
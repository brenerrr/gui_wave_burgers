function [f]=initial_condition(x,type)

switch type
    case 1                      
        for i=1:length(x)
            if x(i)<0
                f(i)=1;
            else
                f(i)=0;
            end            
        end
        
    case 2
        f=1*sin(pi*x);      
        
    case 3
        f=1./(1+5*x.^2);
        
    case 4
        f=1./(1+25*x.^2);
    case 5             
        sizex=length(x);
        tam=round(sizex/6);
        f=zeros(sizex,1);
        flag1=0;
        flag2=0;
        for i=1:sizex
           if x(i)>=-0.8 && x(i)<=-0.1;
               f(i)=x(i)+0.1;
               if flag1 ==0
                   c=f(i);
                   flag1=1;
               end
               f(i)=f(i)-c;
               v=f(i);
           end
           if x(i)>-0.1 && x(i)<0.1
              f(i)=v;
           end
           if x(i)>=0.1 && x(i)<=0.8
              f(i)=-x(i)-0.1;
               if flag2 ==0
                   c=-f(i);
                   flag2=1;
               end
               f(i)=f(i)+c+v;
               
           end
        end
           
       
    case 6
        f=sin(10*pi*x);
        
    case 7
        for i=1:length(x)
            if x(i)<-0.333
                f(i)=1;
            end
            if x(i)>-0.333 && x(i)<0.333
                f(i)=2;
            end
            if x(i)>0.333
                f(i)=1;
            end
        end
        
end

end
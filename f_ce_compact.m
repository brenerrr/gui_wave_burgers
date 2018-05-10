function [line]=f_ce_compact(side,type,size)

switch side
    case 'l'
        switch type
            case 1
                line=zeros(1,size);
                line(1)=1;
                line(2)=1/3;
                line(end-1)=line(2);    
        end
                
    case 'r'
        switch type
            case 1
                line=zeros(1,size);                
                line(2)=1/3;
                line(end)=1;
                line(end-1)=line(2);
        end
end
        
end
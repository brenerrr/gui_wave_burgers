function [cc]=f_ce(side,type,fl,fr,tracker)

switch side
    case 'l'      
        switch type            
            case 1
                cc=fr(tracker);
            case 2 
                cc=0;
            case 3
                cc=(fl(tracker)+fl(tracker+1))/2;
            case 4
                cc=(fl(tracker)*2-fl(tracker-1));
        end
        
    case 'r'
        switch type
            case 1
                cc=fl(tracker);
            case 2
                cc=0;
            case 3
                cc=(fr(tracker)+fr(tracker+1))/2;
        end
end
end

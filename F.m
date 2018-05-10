
function [df_dt]=F(p, x, inp)

switch inp.EQ_TYPE
    case 1 %burgers equation
        switch inp.METHOD 
            case 1 %weno
                %%
                %************************* Fluxes *************************
                f_p = 0.5 * (0.5*p.^2 + p*max(abs(p)));
                f_n = 0.5 * (0.5*p.^2 - p*max(abs(p)));
                
                [vhr_n, ~]=boundaries_weno (f_p, x, inp);
                [~, vhl_n]=boundaries_weno (f_n, x, inp);
                
                flux_r = vhr_n(inp.V1:inp.VN) + vhl_n(inp.V1+1:inp.VN+1) ;
                flux_l = vhr_n(inp.V1-1:inp.VN-1) + vhl_n(inp.V1:inp.VN) ;                
                
                df_dt=-((flux_r-flux_l)/inp.DELTA_X);
            case 2 %eno
                %%
                %************************* Fluxes *************************
                f_p = 0.5 * (0.5*p.^2 + p*max(abs(p)));
                f_n = 0.5 * (0.5*p.^2 - p*max(abs(p)));
                
                [vhr_n, ~]=boundaries_eno (f_p, x, inp);
                [~, vhl_n]=boundaries_eno (f_n, x, inp);
                
                flux_r = vhr_n(inp.V1:inp.VN) + vhl_n(inp.V1+1:inp.VN+1) ;
                flux_l = vhr_n(inp.V1-1:inp.VN-1) + vhl_n(inp.V1:inp.VN) ; 
                
                df_dt=-((flux_r-flux_l)/inp.DELTA_X);
               
            case 3 %compact
                %% 
                f1=1/2*p.^2;
                df_dt=-compact_cdderiv(f1, inp);
                
            case 4 %3p centered 
                %% 
                f1=1/2*p.^2;
                df_dt=-(f1(inp.V1+1:inp.VN+1)-f1(inp.V1-1:inp.VN-1))/(2*inp.DELTA_X);
            case 5 %upwind foward
                %% 
                f1=1/2*p.^2;
                df_dt=-(f1(inp.V1+1:inp.VN+1)-f1(inp.V1:inp.VN))/inp.DELTA_X;
            case 6 %upwind backward
                %%
                f1=1/2*p.^2;
                df_dt=-(f1(inp.V1:inp.VN)-f1(inp.V1-1:inp.VN-1))/inp.DELTA_X;
        end
        
    case 2 %wave equation
        switch inp.METHOD 
            case 1 %weno
                %% 
                %************************* Fluxes *************************
                f_p = 0.5 * (inp.A*p + p*abs(inp.A));
                f_n = 0.5 * (inp.A*p - p*abs(inp.A));
                
                [vhr_n, ~]=boundaries_weno (f_p, x, inp);
                [~, vhl_n]=boundaries_weno (f_n, x, inp);
                
                flux_r = vhr_n(inp.V1:inp.VN) + vhl_n(inp.V1+1:inp.VN+1) ;
                flux_l = vhr_n(inp.V1-1:inp.VN-1) + vhl_n(inp.V1:inp.VN) ; 
                
                df_dt=-((flux_r-flux_l)/inp.DELTA_X);
                
            case 2 %eno
                %% 
                %************************* Fluxes *************************
                f_p = 0.5 * (inp.A*p + p*abs(inp.A));
                f_n = 0.5 * (inp.A*p - p*abs(inp.A));
                
                [vhr_n, ~]=boundaries_eno (f_p, x, inp);
                [~, vhl_n]=boundaries_eno (f_n, x, inp);
                
                flux_r = vhr_n(inp.V1:inp.VN) + vhl_n(inp.V1+1:inp.VN+1) ;
                flux_l = vhr_n(inp.V1-1:inp.VN-1) + vhl_n(inp.V1:inp.VN) ;                
                
                df_dt=-((flux_r-flux_l)/inp.DELTA_X);
              
               
            case 3 %compact
                %% 
                df_dt=-inp.A*compact_cdderiv(p, inp);
                
            case 4 %3p centered 
                %% 
                df_dt=-inp.A*(p(inp.V1+1:inp.VN+1)-p(inp.V1-1:inp.VN-1))/(2*inp.DELTA_X);
                
            case 5 %upwind foward
                %% 
                df_dt=-inp.A*(p(inp.V1+1:inp.VN+1)-p(inp.V1:inp.VN))/inp.DELTA_X;
                
            case 6 %upwind backward
                %%
                df_dt=-inp.A*(p(inp.V1:inp.VN)-p(inp.V1-1:inp.VN-1))/inp.DELTA_X;
           
                
        end

end

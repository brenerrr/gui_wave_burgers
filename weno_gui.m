format longE

% This is a script envoked when an ENO/WENO numerical scheme is marked in
% the GUI

%% Initial Data

export=1;

if export==1   
    p_filename=num2str(i);       
end

% Boundary Conditions
%1: periodic
%2: f=0
%3: (f(i)+f(i+1))/2
%4: 2*f(i)-f(i-1)

inp.CCR=1; % Right
inp.CCL=1; % Left            

inp.EPSILON=1e-8;   % avoid division by zero in weno scheme            

INFX=-1;            % spatial domain
SUPX=1;

INFT=0;             % temporal domain
SUPT=2.5;

CFL=inp.A*inp.DELTA_T/inp.DELTA_X;

inp.N_N_POINTS=inp.TOTAL_POINTS-1;      %number of neighbouring points at the i-th point


inp.EC=inp.N_N_POINTS*2;                % number of boundary condition equations


inp.SIZE_V=inp.N_N_POINTS*2+1;          % size of non divided differences matrix

% Calculate coefficients of WENO differentiation
for r = 1 : inp.TOTAL_POINTS+1
    for n = 1 : inp.TOTAL_POINTS
        inp.CRJ(r,n) = crj(r-2,n-1,inp.TOTAL_POINTS);
    end
end

% Load coefficents for ENO 
inp.TABLE=load('ddcoefficients_withfactorial.txt'); 

%% Calculations

% Spatial mesh
sizex_o=round(SUPX-INFX)/inp.DELTA_X+1;
inp.SIZEX=sizex_o+inp.EC;
x=linspace(INFX-inp.EC/2*inp.DELTA_X,SUPX+inp.EC/2*inp.DELTA_X,inp.SIZEX);

% Temporal mesh
inp.SIZET=(SUPT-INFT)/inp.DELTA_T+1;
t=linspace(INFT,SUPT,inp.SIZET);

% Index of first and last spatial point
inp.V1=inp.EC/2+1;
inp.VN=inp.SIZEX-inp.EC/2;
inp.SIZE_DUMMY=inp.SIZE_V+1;
dummy=zeros(inp.SIZE_DUMMY);

% Initial condition
p=ones(inp.SIZEX,inp.SIZET);
p(:,1)=initial_condition(x,inp.IC);

inp.C=coefficients_weno(inp.N_N_POINTS+1);  % weno coefficients

k=inp.SIZEX-inp.EC; % size of domain without ghost points
h= waitbar(0,'Calculating ...');

for n=1:inp.SIZET-1
    
waitbar(n/(inp.SIZET-1),h,'Calculating ...');
    

y=x(inp.V1 - inp.N_N_POINTS: inp.V1 + inp.N_N_POINTS);

p(:,n+1)=RK2(p(:,n), x, inp);

end

close(h)

MAXU=max(p(:,1));
MINU=min(p(:,1));

step=inp.SIZET/100-mod(inp.SIZET/100,1);

%% Output

if export==1 
    domain_x=x(inp.V1:inp.VN);
    p_export=p(inp.V1:inp.VN,:);
    
    switch inp.EQ_TYPE
        case 1
            exp_eq_type='Burgers';
        case 2
            exp_eq_type='Wave';
    end
    
    switch inp.METHOD
        case  1
            exp_method=['Weno ' num2str(inp.TOTAL_POINTS) ' points/stencil' ];
        case 2
            exp_method=['Eno ' num2str(inp.TOTAL_POINTS) ' points/stencil' ];
            inp.EPSILON=0;
    end
    
 
    data=struct('f',p(inp.V1:inp.VN,:),'domain_x',domain_x,'method',exp_method,'deltax',inp.DELTA_X,'deltat',inp.DELTA_T,'eq_type',exp_eq_type,...
        'filter_order',0,'filter_alpha',0,'epsilon',inp.EPSILON,...
        'domain_t',inp.SIZET,'c_cont_e',inp.CCL,'c_cont_d',inp.CCR,'initial_condition',inp.IC);
  
    save(p_filename,'data')
   
end


    


format longE

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

BETA=0;
D=0;

INFX=-1;            % spatial domain
SUPX=1;

INFT=0;             % temporal domain
SUPT=2.5;

CFL=inp.A*inp.DELTA_T/inp.DELTA_X;

%% Calculation
switch inp.METHOD
    case 3
        inp.EC=4;
    case 4
        inp.EC=2;
    case 5
        inp.EC=2;
    case 6
        inp.EC=2;
end

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

% Initial condition
p=ones(inp.SIZEX,inp.SIZET);
p(:,1)=initial_condition(x,inp.IC);

% Filter parameters
k=inp.SIZEX-inp.EC;
V1f=inp.FILTER*0.5+1;
VNf=k+inp.FILTER-inp.FILTER*0.5;
coef=pentadiagonal(BETA,ALPHA,1,ALPHA,BETA,k);
if inp.CCL==1
    coef(1,k)=ALPHA;
    coef(1,k-1)=BETA;
end
if inp.CCR==1
    coef(k,1)=ALPHA;
    coef(k,2)=BETA;
end
B=zeros(k,1);
switch inp.FILTER
    case 4
    a=1/8*(5+6*ALPHA-6*BETA+16*D);
    b=1/2*(1+2*ALPHA+2*BETA-2*D);
    c=-1/8*(1-2*ALPHA-14*BETA+16*D);

    case 6
    a=1/16*(11+10*ALPHA-10*BETA);
    b=1/32*(15+34*ALPHA+30*BETA);
    c=1/16*(-3+6*ALPHA+26*BETA);
    D=1/32*(1-2*ALPHA+2*BETA);
end

h= waitbar(0,'Calculating ...');


for n=1:inp.SIZET-1
    
    waitbar(n/(inp.SIZET-1),h,'Calculating ...');
    
%   Runge Kutta 4o
    p(:,n+1)=RK4(p(:,n), x, inp); 

%   Filter  
    if inp.FILTER~=0
        p(inp.V1:inp.VN,n+1)=filt(p(inp.V1:inp.VN,n+1),k,a,b,c,D,coef,B,V1f,VNf, inp);
        
    end
    
%   Boundaries after filtering
for i=1:inp.V1-1
        p(i,n+1)=f_ce('l',inp.CCL,p(inp.V1+1:inp.V1+inp.EC/2+1,n+1),p(inp.VN-inp.EC/2:inp.VN,n+1),i);
        p(i+inp.VN,n+1)=f_ce('r',inp.CCR,p(inp.V1+1:inp.V1+inp.EC/2+1,n+1),p(inp.VN-inp.EC/2:inp.VN,n+1),i);
end
 
end
close(h)
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
        case 3
            exp_method='Compact (5 pts in rhs, 3 pts lhs)';
        case 4
            exp_method='Centered (3 pts)';
        case 5
            exp_method='Upwind foward (2 pts)';
        case 6
            exp_method='Upwind backward (2 pts)';
    end
    inp.EPSILON = 0;
    data=struct('f',p(inp.V1:inp.VN,:),'domain_x',domain_x,'method',exp_method,'deltax',inp.DELTA_X,'deltat',inp.DELTA_T,'eq_type',exp_eq_type,...
        'filter_order',0,'filter_alpha',0,'epsilon',inp.EPSILON,...
        'domain_t',inp.SIZET,'c_cont_e',inp.CCL,'c_cont_d',inp.CCR,'initial_condition',inp.IC);
  
    save(p_filename,'data')
     
end

MAXU=max(p(:,1));
MINU=min(p(:,1));

step=inp.SIZET/100-mod(inp.SIZET/200,1);
	
% i=1;
% writerObj = VideoWriter('seno','Motion JPEG AVI') ;
% writerObj.FrameRate = 60;


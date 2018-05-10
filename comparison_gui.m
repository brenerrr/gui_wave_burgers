
% This script basically collects all the data run and plots it in the GUI

%% Set up variables

size_x=zeros(number,1); % Size of spatial domain
desc=cell(number,1);    % Solutions Descriptor
leg=cell(number,1);     % Legend

%% Load first solution

temp=load(local_y{1});
A = struct2cell(temp.data);
f=zeros(number,length(temp.data.domain_x),temp.data.domain_t);
x=zeros(number,length(temp.data.domain_x));
f(1,:,:) = cat(2,A{1});
x(1,:) = cat(2,A{2});

l_temp=strcat(A(3) ,' with dx = ', num2str(A{4}));
leg(1)=cellstr(l_temp);
desc_temp = sprintf('\n %s \n dx = %.3f \n dt = %.3f \n %s \n Filter order %.0f \n Filter alpha %.2f \n Epsilon %.0e \n CC left = %.0f \n CC right = %.0f \n Initial Condition %.0f \n',...
    A{3},A{4},A{5},A{6},A{7},A{8},A{9},A{11},A{12},A{13});
size_desc=length(desc_temp);
desc{1}=desc_temp;
disp(desc{1,:})

size_t=temp.data.domain_t;

%% Load more solutions if there are any
if number >1 
    for i=2:number
        temp=load(local_y{i});
        A = struct2cell(temp.data);        
        size_x(i)=length(temp.data.domain_x);
        f(i,1:size_x(i),:) = A{1};
        x(i,1:size_x(i)) = A{2};        
        l_temp=strcat(A(3) ,' with dx = ', num2str(A{4}));
        leg(i)=cellstr(l_temp);
        desc_temp = sprintf('\n %s \n dx = %.3f \n dt = %.3f \n %s \n Filter order %.0f \n Filter alpha %.2f \n Epsilon %.0e \n CC left = %.0f \n CC right = %.0f \n Initial condition %.0f \n',...
            A{3},A{4},A{5},A{6},A{7},A{8},A{9},A{11},A{12},A{13});
        size_desc=length(desc_temp);
        desc{i}=desc_temp;
        disp(desc{i,:})

    end

end

%% Plot 

gama=50;
interval=round(size_t/gama);

INFX=x(1,1);
SUPX=x(1,end);

MINY=min(f(1,:,1));

MAXY=max(f(1,:,1));

p_time=0.1;

clc
time=1;

axes(handles.axes3)

if inp.EQ_TYPE==2 && analytical==1    
    sizexa=1000;
    xa=linspace(INFX,SUPX,sizexa);
    fa=initial_condition(xa,inp.IC);
    flag=1;
end

if analytical_burgers==1 && exist('analytical_burgers', 'file') == 2
   dados_analytical_burgers=load('analytical_burgers'); 
   fa=dados_analytical_burgers.data.f;
   xa=dados_analytical_burgers.data.domain_x;
   delta=inp.DELTA_T/dados_analytical_burgers.data.deltat;
end

for n=1:interval:size_t*time-1
         
        plot(x(1,:),f(1,:,n),g_code{1},'markersize',8,'LineWidth',1.5);
        hold on 
        set(gca,'Color',[0 0 0]);
        if number > 1
            for i=2:number
                plot(x(i,1:size_x(i)),f(i,1:size_x(i),n),g_code{i},'markersize',8,'LineWidth',2);
            end
        end        
        if flag==1
            [xa, fa]=periodicidade_analitica(fa,xa,INFX,SUPX,sizexa);
            plot(xa,fa,'w--','LineWidth',2)
            xa=xa+inp.A*inp.DELTA_T*interval;
        end
        if analytical_burgers==1 && exist('analytical_burgers', 'file') == 2
           t=delta*n;
           plot(xa,fa(:,t),'w-','LineWidth',3); 
        end
        
        axis([INFX SUPX MINY-.1 MAXY+.1])        
        axis square
        grid on 
        xlabel('x')
        ylabel('y')
        set(gca,'Xcolor',[0.3 0.3 0.3]);
        set(gca,'Ycolor',[0.3 0.3 0.3]);
        set(gca,'GridLineStyle','-')
        hold off         
        pause(p_time)        
        
        
end


legend(leg)
set(legend,'Textcolor','w')

% ahtteo_01 [script]

clc, clear, close all

% reta qualquer
fig=figure;
% Reta 1
x=0:1:12;
m=5; % coef angular
n=10;  % interseção da reta com o eixo y
xpr1=[2 4 6 8 10]; 
ypr1 = TraceReta(x, m, n, xpr1, fig);

% Reta 2
m=10; % coef angular
n=5;  % interseção da reta com o eixo y
xpr2=[2 4 6 8 10]; 
ypr2 = TraceReta (x, m, n, xpr1, fig);

% determinar o espaço c,k da HT
% d (interception) em funçao de k (coef angular)

k=0:1:15; % vetor de coef angulares, define e resolução da HT
acumula=zeros([15 15]);

fig=figure;
EspacoHT(k, xpr1, ypr1, fig, acumula);
EspacoHT(k, xpr2, ypr2, fig, acumula);

function EspacoHT (k, xp, yp, fig, acumula)

    for i=1:1:5
       d = -k.*xp(i) + yp(i); %interceptions de todas as retas que passam por xp,yp, com m
       plot(k, d); grid on; hold on  
       % acumula(c,k)=acumula(c,k)+1;
    end 
    xlabel('k - coef angular')
    ylabel('d - pontos de interseção')
    title('k d Parameter Space da Hough Transform');
    ylim([0 15])
    xlim([0 15])
end

function yp = TraceReta (x, m, n, xp, fig)
    y=m.*x+n; 
    fig=plot(x,y, Color='b', LineWidth=2); grid on; hold on
    
    yp=m.*xp+n; 
    for i=1:1:size(xp,2) 
        fig=plot(xp(i),yp(i),'o', Color='b', LineWidth=2);
    end
    xlabel('x')
    ylabel('y=m*x+n')
    title('Imagens com Retas');
end




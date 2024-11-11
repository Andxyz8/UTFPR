% ahtteo_02 [script]

clc, clear, close all

% reta qualquer

xp=[ 2,  4,  6,  6,  8,  10];
yp=[25, 45, 65, 35, 85, 105];

figure;
for i = 1 : 1 : 6
    plot(xp(i), yp(i), 'o', Color='b'); hold on, grid on;
end

title('x/y image space')

x=0:10/1000:10;
y=10*x+5;
plot(x,y); grid on;

y=2.5*(2:10)+20;
plot((2:10), y);

% Parameter Space da HT d/k
k=0:1:15; % vetor de coef angulares, define e resolução da HT

fig=figure;
EspacoHT(k, xp, yp, fig);

function EspacoHT (k, xp, yp, fig)
    for i=1:1:6
       d = -k.*xp(i) + yp(i); %interceptions de todas as retas que passam por xp,yp, com m
       plot(k, d); grid on; hold on
    end 
    xlabel('k - coef angular')
    ylabel('d - pontos de interseção')
    title('k/d Parameter Space da Hough Transform');
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




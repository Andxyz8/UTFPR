% ahtteo_03 [script]

clc, clear, close all

x1=1;
x2=3;
x3=7;
x4=9;

y1=4;
y2=8;

xp=[x1 2 x2 x2 5  x3 x3  5 x4 8];
yp=[y1 6 y2 y1 y2 y1 y2 y1 y2 6];

fig(1)=figure;
for i = 1:1:10
    plot(xp(i), yp(i), "o", Color='r'); hold on;
end
xlim([0 10]);
ylim([0 10]);

x=1:1:10;
m=0; n=8; yr=m.*x+n;
plot(x,yr); hold on

m=0; n=4; yr=m.*x+n;
plot(x,yr);

m=2; n=2; yr=m.*x+n;
plot(x,yr);

m=2; n=-10; yr=m.*x+n;
plot(x,yr);

xlim([0 10]);
ylim([0 10]);

% Parameter Space da HT d/k
k=0:1:15; % vetor de coef angulares, define e resolução da HT

fig(2)=figure;
EspacoHT(k, xp, yp, fig(2));

function EspacoHT (k, xp, yp, fig)
    for i=1:1:size(xp,2)
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


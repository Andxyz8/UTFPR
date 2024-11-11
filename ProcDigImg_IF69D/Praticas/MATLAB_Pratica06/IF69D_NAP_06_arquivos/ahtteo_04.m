% ahtteo_04 [script]

% Transformada de Hough usando Hessian Normal Form (HNF)
% pag 357 do livro do Burger & Burger Digital Image Processing

clc, clear, close all

x=0:20/500:20;
m=1;
n=-5; %interseption
y=m.*x+n;
figure, plot(x, y); grid on
ylim([-10 20])
xlim([0 20])

theta=0:2*pi/500:2*pi;
figure,
for i=1:1:500
    r=x(i).*cos(theta)+y(i).*sin(theta);
    plot(theta, r, Color='b'); grid on, hold on
end

r=x(30).*cos(theta)+y(30).*sin(theta);
plot(theta, r, Color='r');

r=x(50).*cos(theta)+y(50).*sin(theta);
plot(theta, r, Color='c');

r=x(80).*cos(theta)+y(80).*sin(theta);
plot(theta, r, Color='m');

r=x(90).*cos(theta)+y(90).*sin(theta);
plot(theta, r, Color='k');

% prova dos nove: traçar a reta com os valores de r e theta do parameter
% space e verificar se é igual a reta inicial.
theta_ht=2.37504;
r=-3.56316;
yr= ( r - x*cos(theta_ht) ) / ( sin(theta_ht) );

figure, plot(x,yr); grid on;
ylim([-10 20])
xlim([0 20])

% a03_03_pre [script]
clc, clear, close all

%Funcao log
%Logaritmo neperiano (base e)
y = log(1:1000); 

%Display
figure
plot(y)
grid on
title('log function')
xlabel('x')
ylabel('y = log(x)')
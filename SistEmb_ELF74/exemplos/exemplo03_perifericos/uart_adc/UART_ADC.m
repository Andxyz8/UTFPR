% Limpar ambiente
clear all;
close all;
clc;

% Encontrar quaisquer objetos seriais existentes e fechá-los se estiverem abertos
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

s = serial('COM6', 'BaudRate', 115200, 'Terminator', 'LF');
fopen(s);

% Preparar a figura
h = figure;
hold on;
grid on;
box on;
set(gcf,'color','w');
xlabel('Número da Amostra');
ylabel('Valor do ADC');

xlim([1, 100]); % Limite inicial do eixo x
ylim([0, 4095]); % Ajustar o limite do eixo y para corresponder a resolução do ADC

% Inicializar o gráfico
n = 0; 
dataValues = []; 
hLine = plot(nan, nan, 'b-','LineWidth',2); % Objeto de plotagem inicial sem dados visíveis

% Loop até que a figura seja fechada
while ishandle(h)
    if s.BytesAvailable > 0
        data = fscanf(s, '%d'); % Ler dados da porta serial
        n = n + 1; % Incrementar o número da amostra
        dataValues(end + 1) = data; % Anexar novos dados

        % Atualizar o gráfico
        set(hLine, 'XData', 1:n, 'YData', dataValues); % Atualizar dados x e y do gráfico

        % Rolar o eixo x
        if n > 100
            xlim([n-99, n]); % Manter a janela dos últimos 100 amostras
        end

        drawnow; % Atualizar a figura
    end
end

% Fechar a porta serial
fclose(s);
delete(s);
clear s;

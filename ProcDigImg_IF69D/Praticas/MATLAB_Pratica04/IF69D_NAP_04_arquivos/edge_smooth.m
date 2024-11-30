% edge_smooth [script]
clc, clear, close all

%Cria imagem
nr = 16; nc = 16;
a = triu(ones(nr,nc))*64;
b = tril(ones(nr,nc),-1)*192;
g = uint8(a+b);

%Média zero e desvio padrão 20
gg = imnoise(g,'gaussian',(0/255),(20/255)^2);

%Filtro da média
h = fspecial('average', [3 3]);
ggm1 = imfilter(gg, h, 'symmetric');
h = fspecial('average', [7 7]);
ggm2 = imfilter(gg, h, 'symmetric');

%Display
figure, image(g), colormap(gray(256))
title('Original','FontWeight','bold')
figure, image(gg), colormap(gray(256))
title('Com ruído','FontWeight','bold')
figure, mesh(double(g),'EdgeColor','black')
title('Original','FontWeight','bold')
figure, mesh(double(gg),'EdgeColor','black')
title('Com ruído','FontWeight','bold')
figure, mesh(double(ggm1),'EdgeColor','black')
title('Média 3x3','FontWeight','bold')
figure, mesh(double(ggm2),'EdgeColor','black')
title('Média 7x7','FontWeight','bold')
x = 1:size(g,2);
i = ceil(size(g,1)/2);
figure
plot(x,g(i,:),x,gg(i,:),...
    x,ggm1(i,:),x,ggm2(i,:)),
legend('Original','Com ruído',...
    'Média 3x3', 'Média 7x7')
title(['Perfil da linha ',...
    num2str(i)],'FontWeight','bold')
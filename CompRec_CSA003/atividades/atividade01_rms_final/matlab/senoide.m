function valor = rms (x)
    a = 0;
    for i=1:length(x)
        a = a+ x(i)*x(i);
    end
    valor = round(sqrt(a/length(x)));
end

y = [0:1:255];

rms (round((sin(y/32)+1)*128))


x = round((sin(y/32)+1)*128);
plot(x)

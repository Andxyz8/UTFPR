import matplotlib.pyplot as plt
import numpy as np

#Vídeo explicativo no Youtube <LINK>: https://youtu.be/LHyVU4kb_ys

g = 9.81 #gravidade (m/s^2)
m = 2000000 #massa total inicial (kg)
Vc = 2600 #Velocidade de exaustão do combustível (m/s) -> imp esp * g
k = 9600 #Velocidade de queima do combustível (kg/s)

tcc = ((9 / 10) * m) / k #Tempo para consumo do combustivel (90% de m)

t = np.arange(0.0, tcc, 0.0001) #tempo

print("Tempo de consumo do combustivel: ", tcc,"s.")


s = Vc*(t - ((m - k * t) / k) * np.log(m / (m - k*t))) - (g * t * t) / 2 #Equação da posição

hMax = Vc*(tcc - (m / (10*k)) * np.log(10)) - (g * tcc * tcc) / 2; #Altura máxima


print("Altura máxima", (hMax/1000), "km.")

v = Vc * np.log(m / (m - k*t)) - g * t

vMax = Vc * np.log(10) - g * tcc; #Velocidade máxima

print("Velocidade Máxima", (vMax), "m/s.")

plt.plot(t, s/1000)
plt.xlabel("Tempo [s]")
plt.ylabel("Altitude [km]")
plt.title("Altitude x Tempo")
plt.grid()
plt.show()

plt.plot(t, v)
plt.xlabel("Tempo [s]")
plt.ylabel("Velocidade [m/s]")
plt.title("Velocidade x Tempo")
plt.grid()
plt.show()

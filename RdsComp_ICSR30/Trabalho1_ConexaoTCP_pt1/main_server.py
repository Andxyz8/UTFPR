from servidor.server import Servidor

# Endereço IP do servidor
HOST = "0.0.0.0"
# Porta utilizado para o bind do servidor
PORT = 8888
# Máximo de conexões em espera até que novas conexões sejam rejeitadas
MAX_QUEUE = 3

if __name__ == "__main__":
    servidor = Servidor(HOST, PORT, MAX_QUEUE)
    servidor.executar()

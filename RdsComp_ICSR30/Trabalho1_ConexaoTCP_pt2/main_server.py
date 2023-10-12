from servidor.server import Servidor

# Endereço IP do servidor
HOST = "127.0.0.1"
# Porta utilizado para o bind do servidor
PORT = 8888
# Máximo de conexões em espera até que novas conexões sejam rejeitadas
MAX_QUEUE = 3

if __name__ == "__main__":
    servidor = Servidor(HOST, PORT, MAX_QUEUE)
    servidor.executar()

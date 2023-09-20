from cliente.client import Cliente

HOST = "127.0.0.1"
PORT = 8888

if __name__ == "__main__":
    cliente = Cliente(HOST, PORT)
    cliente.executar()

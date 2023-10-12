from socket import (
    socket,
    AF_INET, # FAMÍLIA DE ENDEREÇOS QUE USA UM PAR (host, port)
    SOCK_STREAM # TIPO DO SOCKET USADO (padrão)
)
from servidor.client_handler import ClientHandler

class Servidor:
    def __init__(self, host: str, port: int, max_queue: int) -> None:
        self.__host = host
        self.__port = port
        self.max_queue = max_queue
        self.requests_possiveis = ['SAIR', 'ARQUIVO', 'ARQUIVO2', 'CHAT']

        # Criação do Socket TCP/IP do Servidor
        self.server = socket(
            family = AF_INET,
            type = SOCK_STREAM
        )

    def __inicializa_servidor(self) -> None:
        # Vincula o servidor ao host e porta fornecidos
        self.server.bind((self.__host, self.__port))

        # Define o máximo de conexões em espera antes de rejeitar novas conexões
        self.server.listen(self.max_queue)

        print(f"Servidor ATIVO e RECEBENDO CONEXÕES na porta {self.__port}")

    def executar(self) -> None:
        """Inicializa o servidor e faz com que qualquer conexão recebida seja aceita.
        
        - Dispara uma Thread para lidar com a o cliente para cada conexão recebida.
        """
        self.__inicializa_servidor()

        # Servidor permanece executando
        while True:
            # Aceita uma conexão qualquer de clientes
            client_socket, endereco = self.server.accept()

            host = endereco[0]
            port = endereco[1]
            print(f"[INFO]: Conexão aceita de {host}:{port}.")

            # Dispara uma Thread para lidar com a conexão do cliente
            tratador_clientes = ClientHandler(
                client_socket,
                host,
                port,
                self.requests_possiveis
            )
            tratador_clientes.iniciar()

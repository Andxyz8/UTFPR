from sys import exit as sys_exit
from os.path import isfile
from socket import socket
from threading import Thread
from time import sleep

class ClientHandler(Thread):
    SERVING_DIR: str = "./src"

    def __init__(
        self,
        cliente: socket,
        host: str,
        port: int,
        resquests_possiveis: list
    ) -> None:
        super().__init__(
            target = self.__trata_cliente
        )

        self.__host = host
        self.__port = port
        self.__client_socket = cliente
        self.__requests_possiveis = resquests_possiveis

    def __recebe_request_cliente(self) -> str:
        """Lê uma mensagem em bytes enviada pelo cliente.

        Returns:
            str: mensagem enviada pelo cliente.
        """
        # Recebe os dados enviados pelo cliente tratado pela thread
        bytes_recebidos = self.__client_socket.recv(1024)

        # Retorna os dados recebidos convertidos para string
        return bytes_recebidos.decode("utf-8")

    def __envia_mensagem_cliente(self, mensagem) -> None:
        """Envia uma mensagem para o cliente.

        Args:
            mensagem (str): mensagem a ser enviada para o cliente.
        """
        bytes_mensagem = mensagem
        if isinstance(mensagem, str):
            # print(f"Mensagem: {mensagem}")
            bytes_mensagem = mensagem.encode("utf-8")

        sleep(0.05)
        self.__client_socket.send(bytes_mensagem)

    def __identifica_request_valida(self, mensagem) -> None:
        """Identifica o tipo de request enviado pelo cliente.

        Args:
            mensagem (str): mensagem enviada pelo cliente.
        """
        request = mensagem.upper().split(' ')[0]

        if request in self.__requests_possiveis:
            print(f"[REQUEST]: {self.__host}:{self.__port} -> [{request}]")
            return True
        print(f"[TRASH]: {self.__host}:{self.__port} -> {mensagem}")
        return False

    def __mensagem_get(self, request: str) -> None:
        """Verifica se o cliente enviou a mensagem `GET`.

        Se sim, tudo que for digitado no servidor será enviado para o cliente 
            que enviou a mensagem `chat`.

        Args:
            mensagem (str): request solicitada pelo cliente.
        """
        request_parts = request.split(' ')
        method = request_parts[0]
        page = request_parts[1]
        if method == "GET":
            path = self.SERVING_DIR + page
            print(f"PATH: {path}")
            if isfile(path):
                # Arquivo encontrado, envia a resposta
                with open(path, "rb") as file:
                    content = file.read()
                response = "HTTP/1.1 200 OK\r\n\r\n"
                
                self.__envia_mensagem_cliente(response)
                self.__envia_mensagem_cliente(content)
            else:
                # Arquivo não encontrado, envia resposta de erro 404
                response = "HTTP/1.1 404 Not Found\r\n\r\n"
                self.__client_socket.send(response.encode("utf-8"))
        else:
            # Método HTTP não suportado, envia resposta de erro 501
            response = "HTTP/1.1 501 Not Implemented\r\n\r\n"
            self.__client_socket.send(response.encode("utf-8"))
        self.encerra_conexao()
        print(f"[RESPONSE] - {response}")

    def encerra_conexao(self) -> None:
        """Finaliza a conexão com o cliente.
        """
        # Fecha o socket do cliente
        self.__client_socket.close()

        print(f"[INFO]: conexão encerrada com {self.__host}:{self.__port}.")

        # Encerra a Thread responsável pela conexão
        sys_exit(0)

    def __trata_cliente(self) -> None:
        """Trata as requisições do cliente e envia as respostas adequadas.

        - Se o cliente enviar a mensagem SAIR, encerra a conexão com o cliente.
        - Se o cliente enviar a mensagem ARQUIVO faz os processamentos adequados
            e envia a resposta para o cliente.
        - Se o cliente enviar a mensagem CHAT, habilita o chat para esta conexão.
        """
        try:
            while True:
                dados_recebidos = self.__recebe_request_cliente()
                print(
                    "ESTA FOI A REQUISIÇÃO:\n"
                    +f"{dados_recebidos}\n"
                    +"===================="
                )
                if not self.__identifica_request_valida(dados_recebidos):
                    resposta_padrao = "REQUEST INVALIDA"
                    self.__envia_mensagem_cliente(resposta_padrao)
                    continue

                # Tratamentos possiveis de acordo com a requisição do cliente
                self.__mensagem_get(dados_recebidos)
        except ConnectionAbortedError:
            self.encerra_conexao()

    def iniciar(self):
        """Inicia a thread para tratar do cliente."""
        print(f"[INFO]: Thread disparada. Conexão -> {self.__host}:{self.__port}""")
        self.start()

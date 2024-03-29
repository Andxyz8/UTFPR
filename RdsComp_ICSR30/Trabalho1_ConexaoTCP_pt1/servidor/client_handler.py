import sys
import json
from socket import socket
from threading import Thread
from time import sleep
from utils import hash_operator

class ClientHandler(Thread):
    def __init__(self, cliente: socket, host: str, port: int, resquests_possiveis: list) -> None:
        super().__init__(
            target = self.__trata_cliente
            # args = (cliente,)
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

    def __finaliza_conexao(self) -> None:
        """Finaliza a conexão com o cliente.
        """
        # Fecha o socket do cliente
        self.__client_socket.close()

        # Encerra a Thread responsável pela conexão
        sys.exit(0)

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

    def __mensagem_sair(self, mensagem) -> None:
        """Verifica se o cliente enviou a mensagem SAIR e finaliza a conexão.

        Args:
            mensagem (str): mensagem enviada pelo cliente.
        """
        if mensagem.upper() == "SAIR":
            # Informa no servidor que o cliente solicitou o encerramento da conexão
            print(f"[INFO]: Encerrando conexão com {self.__host}:{self.__port}.")

            # Define a resposta para o cliente
            response = "SAIR"

            self.__envia_mensagem_cliente(response)

            self.__finaliza_conexao()

    def __obtem_nome_arquivo(self, mensagem) -> str:
        """Obtém o nome do arquivo a partir da mensagem enviada pelo cliente.

        Args:
            mensagem (str): mensagem enviada pelo cliente.

        Returns:
            str: nome do arquivo.
        """
        if '/' in mensagem:
            nome_arquivo = mensagem.split("/")[-1]
        else:
            nome_arquivo = mensagem.split(" ")[-1]

        return nome_arquivo

    def __obtem_infos_arquivo(self, nome_arquivo) -> dict:
        """Obtém as informações do arquivo em um dicionário.

        Args:
            nome_arquivo (str): nome do arquivo.

        Returns:
            dict: informações do arquivo.
        """
        infos_arquivo = {}
        try:
            # Abre o arquivo para leitura usando with
            with open(nome_arquivo, "rb") as arquivo:
                # Obtém o nome do arquivo
                infos_arquivo['nome'] = nome_arquivo

                extensao_arquivo = nome_arquivo.split('.')[-1]

                # Leitura dos bytes do arquivo
                bytes_arquivo = arquivo.read()

                if extensao_arquivo == 'txt':
                    # Faz a leitura dos dados do arquivo
                    infos_arquivo['dados'] = bytes_arquivo.decode("utf-8")
                else:
                    # Faz a leitura dos dados do arquivo
                    infos_arquivo['dados'] = bytes_arquivo

                # Obtém o tamanho do arquivo
                infos_arquivo['tamanho'] = len(bytes_arquivo)

                # Obtém o hash do arquivo
                infos_arquivo['hash'] = hash_operator.calcula_hash(bytes_arquivo)

                infos_arquivo['status'] = "200"
                # infos_arquivo['mensagem'] = f"Arquivo {nome_arquivo} encontrado."

                # fecha o arquivo
                arquivo.close()
        except FileNotFoundError:
            infos_arquivo['nome'] = "0"
            infos_arquivo['dados'] = "0"
            infos_arquivo['tamanho'] = 0
            infos_arquivo['hash'] = "0"
            infos_arquivo['status'] = "404"
            # infos_arquivo['mensagem'] = f"Arquivo {nome_arquivo} não encontrado."
        return infos_arquivo

    def __mensagem_arquivo(self, mensagem) -> None:
        """Verifica se o cliente enviou a mensagem ARQUIVO faz os processamentos
            adequados e envia a resposta para o cliente.

        - Se o arquivo for encontrado, envia:
            - `nome do arquivo`
            - `tamanho do arquivo em bytes`
            - `hash do arquivo`
            - `status 200`

        - Se o arquivo não for encontrado, envia:
            - `status 404`

        Args:
            mensagem (str): mensagem enviada pelo cliente.
        """
        # Recebe o nome do arquivo
        nome_arquivo = self.__obtem_nome_arquivo(mensagem)

        # Obtém as informações do arquivo
        infos_arquivo = self.__obtem_infos_arquivo(nome_arquivo)

        # Se o cliente enviar a mensagem HASH, calcula o hash do arquivo
        if 'ARQUIVO2' in mensagem.upper().split(' ')[0]:
            resposta = "ARQUIVO2"
            self.__envia_mensagem_cliente(resposta)

            # Transforma o arquivo em json
            json_infos_arquivo = json.dumps(infos_arquivo, indent = 4)

            # Envia o dados do arquivo para o cliente
            self.__envia_mensagem_cliente(json_infos_arquivo)
        elif 'ARQUIVO' in mensagem.upper().split(' ')[0]:
            resposta = "ARQUIVO"
            self.__envia_mensagem_cliente(resposta)

            # Envia o nome do arquivo para o cliente
            self.__envia_mensagem_cliente(nome_arquivo)

            # Envia o tamanho do arquivo para o cliente
            self.__envia_mensagem_cliente(str(infos_arquivo['tamanho']))

            # Envia o hash do arquivo para o cliente
            self.__envia_mensagem_cliente(infos_arquivo['hash'])

            # Envia o status do arquivo para o cliente
            self.__envia_mensagem_cliente(infos_arquivo['status'])

            # Envia o arquivo para o cliente
            self.__envia_mensagem_cliente(infos_arquivo['dados'])


    def __mensagem_chat(self, mensagem: str) -> None:
        """Verifica se o cliente enviou a mensagem `CHAT`.

        Se sim, tudo que for digitado no servidor será enviado para o cliente 
            que enviou a mensagem `chat`.

        Args:
            mensagem (str): mensagem enviada pelo cliente.
        """
        # Se o cliente enviar a mensagem CHAT, habilita o chat para esta conexão
        if 'CHAT' == mensagem.upper():
            # Indica ao cliente que o chat foi iniciado e ele pode começar a enviar mensagens
            resposta = "CHAT"
            self.__envia_mensagem_cliente(resposta)

            # Loop de recebimento de mensagens do cliente
            while True:
                mensagem = self.__recebe_request_cliente()

                print(f"[CHAT] {self.__host}:{self.__port} -> {mensagem}")

                # keyword para encerrar o recebimento de mensagens do cliente
                if 'SAIR CHAT' == mensagem.upper():
                    resposta = "SAIR CHAT"
                    self.__envia_mensagem_cliente(resposta)
                    print(f"{self.__host}:{self.__port} -> Encerrou CHAT.")
                    break

            while True:
                # Envia mensagens indefinidamente ao cliente até que seja informado sair chat
                mensagem = input('SERVIDOR INPUT: ')
                self.__envia_mensagem_cliente(mensagem)

                if mensagem.upper() == 'SAIR CHAT':
                    print("SERVIDOR -> Encerrou CHAT.")
                    break

    def __trata_cliente(self) -> None:
        """Trata as requisições do cliente e envia as respostas adequadas.

        - Se o cliente enviar a mensagem SAIR, encerra a conexão com o cliente.
        - Se o cliente enviar a mensagem ARQUIVO faz os processamentos adequados
            e envia a resposta para o cliente.
        - Se o cliente enviar a mensagem CHAT, habilita o chat para esta conexão.
        """
        while True:
            dados_recebidos = self.__recebe_request_cliente()

            if not self.__identifica_request_valida(dados_recebidos):
                resposta_padrao = "REQUEST INVALIDA"
                self.__envia_mensagem_cliente(resposta_padrao)
                continue

            # Tratamentos possiveis de acordo com a requisição do cliente
            self.__mensagem_sair(dados_recebidos)

            self.__mensagem_arquivo(dados_recebidos)

            self.__mensagem_chat(dados_recebidos)

    def iniciar(self):
        """Inicia a thread para tratar do cliente."""
        print(f"[INFO]: Thread disparada. Conexão -> {self.__host}:{self.__port}""")
        self.start()

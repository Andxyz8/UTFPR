import sys
from socket import (
    socket,
    AF_INET, # FAMÍLIA DE ENDEREÇOS QUE USA UM PAR (host, port)
    SOCK_STREAM # TIPO DO SOCKET USADO (padrão)
)
from utils import hash_operator

class Cliente:
    def __init__(self, host, port) -> None:
        self.__host = host
        self.__port = port

        self.__path_client = "./cliente/"

        # Cria um socket TCP/IP para o cliente
        self.client = socket(
            family = AF_INET,
            type = SOCK_STREAM
        )

    def __inicializa_conexao(self) -> None:
        # Faz a conexão com o servidor na porta especificada
        self.client.connect((self.__host, self.__port))

        print(f"Conectado no servidor {self.__host}:{self.__port}.")

    def __recebe_resposta_servidor(self) -> str:
        # Recebe a resposta do servidor
        byte_resposta = self.client.recv(1024)

        # Obtem em string a resposta do servidor
        str_resposta = byte_resposta.decode('utf-8')

        # print(str_resposta)
        return str_resposta

    def __resposta_sair(self, resposta: str) -> None:
        if resposta.upper() == "SAIR":
            print("[INFO]: Encerrando conexão com o servidor.")
            self.client.close()
            sys.exit(0)

    def __resposta_arquivo_curta(self, resposta: str) -> None:
        if resposta.upper() == "ARQUIVO2":
            #  Exibe informações do arquivo
            print(f"JSON dos dados do arquivo: {self.__recebe_resposta_servidor()}")

    def __recebe_infos_arquivo(self) -> dict:
        # Recebe o nome do arquivo
        nome_arquivo = self.__recebe_resposta_servidor()

        # Recebe o tamanho do arquivo
        tamanho_arquivo = float(self.__recebe_resposta_servidor())

        # Recebe o hash do arquivo
        hash_arquivo = self.__recebe_resposta_servidor()

        # Recebe os dados do arquivo
        dados_arquivo = self.__recebe_resposta_servidor()

        # Recebe o status do arquivo
        status = self.__recebe_resposta_servidor()

        # Retorna um dicionário com as informações do arquivo
        return {
            "nome_arquivo": nome_arquivo,
            "tamanho_arquivo": tamanho_arquivo,
            "hash_arquivo": hash_arquivo,
            "dados_arquivo": dados_arquivo,
            "status": status
        }

    def __verifica_hash(self, dados_arquivo: str, hash_arquivo: str) -> bool:
        # Calcula o hash do arquivo recebido no lado do cliente
        hash_calculado = hash_operator.calcula_hash(dados_arquivo.encode("utf-8"))

        # Verifica se o hash do arquivo recebido é igual ao hash calculado
        if hash_calculado != hash_arquivo:
            return False
        return True

    def __salva_arquivo(self, nome_arquivo, dados_arquivo, hash_arquivo, status) -> None:
        # Verificar o hash do arquivo recebido
        flag_hash_valido = self.__verifica_hash(
            dados_arquivo,
            hash_arquivo
        )

        if status == "200":
            if flag_hash_valido:
                print("[INFO]: Hash do arquivo VÁLIDO. Arquivo Salvo.")

                file_path = f"{self.__path_client}{nome_arquivo}"

                with open(file_path, "wb") as arquivo:
                    arquivo.write(dados_arquivo.encode("utf-8"))
            else:
                print("[INFO]: Hash do arquivo INVÁLIDO. Arquivo NÃO Salvo.")
        else:
            print("[INFO]: Arquivo NÃO encontrado. Arquivo NÃO Salvo.")

    def __resposta_arquivo_longa(self, resposta: str) -> None:
        if resposta.upper() == "ARQUIVO":
            # Obtem as informações do arquivo
            infos_arquivo = self.__recebe_infos_arquivo()

            # Verifica se o arquivo possui o hash válido e o salve caso positivo
            self.__salva_arquivo(
                infos_arquivo['nome_arquivo'],
                infos_arquivo['dados_arquivo'],
                infos_arquivo['hash_arquivo'],
                infos_arquivo['status']
            )

    def __resposta_chat(self, resposta: str) -> None:
        if resposta.upper() == "CHAT":
            while True:
                # input da mensagem a ser enviada para o chat do servidor
                mensagem = input("INPUT MENSAGEM: ")

                # Envia a mensagem para o servidor
                self.client.send(f"{mensagem}".encode('utf-8'))
                if mensagem.upper() == "SAIR CHAT":
                    resposta = self.__recebe_resposta_servidor()
                    if resposta == "SAIR CHAT":
                        print("[INFO]: Encerrado o envio de mensagens ao servidor.")
                        break

            # Recebe a mensagem do servidor
            while True:
                mensagem = self.__recebe_resposta_servidor()

                if mensagem.upper() == "SAIR CHAT":
                    print("[INFO]: Encerrado o recebimento de mensagens do servidor.")
                    break

                # Exibe a mensagem do servidor
                print(f"[CHAT] SERVIDOR: {mensagem}")

    def executar(self):
        self.__inicializa_conexao()

        requisicao = ""

        while True:
            # Solicita ao usuário a requisição para enviar ao servidor
            requisicao = input("REQUEST SERVER: ")

            # Envia a requisicao para o servidor
            self.client.send(f"{requisicao}".encode('utf-8'))

            resposta = self.__recebe_resposta_servidor()
            if resposta == "REQUEST INVALIDA":
                continue

            self.__resposta_sair(resposta)

            self.__resposta_arquivo_curta(resposta)

            self.__resposta_arquivo_longa(resposta)

            self.__resposta_chat(resposta)

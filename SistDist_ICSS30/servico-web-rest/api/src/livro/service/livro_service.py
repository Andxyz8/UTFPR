from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from base64 import urlsafe_b64decode, urlsafe_b64encode
from operators.operador_banco_dados import OperadorBancoDados
from src.models.livro import Livro


class LivroService:
    def __init__(self):
        self.operador_banco_dados = OperadorBancoDados()

    def __obtem_livros_cadastrados(self) -> dict:
        query_select = """
            SELECT
                id_livro,
                nome AS titulo,
                genero,
                autor
            FROM livro;
        """
        response_qry = self.operador_banco_dados.executa_select(query_select)
        if response_qry['status'] != 200:
            return response_qry

        df_livros = self.operador_banco_dados.df_consulta

        if df_livros.empty:
            return {
                'status': 404,
                'mensagem': 'Nenhum livro cadastrado.'
            }

        return {
            'status': 200,
            'livros': df_livros
        }

    def __obtem_infos_livro_individual(self, id_livro: int) -> dict:
        query_select = f"""
            SELECT
                id_livro,
                nome AS titulo,
                genero,
                autor
            FROM livro
            WHERE id_livro = {id_livro};
        """

        response_qry = self.operador_banco_dados.executa_select(query_select)

        if response_qry['status'] != 200:
            return response_qry

        df_livro = self.operador_banco_dados.df_consulta

        if df_livro.empty:
            return {
                'status': 404,
                'mensagem': 'Livro não encontrado.'
            }
        return {
            'status': 200,
            'livro': df_livro
        }

    def __cadastra_livro_banco_dados(
        self,
        nome: str,
        # qtd_paginas: int,
        # data_publicacao: str,
        genero: str,
        autor: str,
        # resumo: str
    ) -> dict:
        query_insert = f"""
            INSERT INTO livro (
                nome,
                qtd_paginas,
                data_publicacao,
                genero,
                autor,
                resumo
            ) VALUES (
                '{nome}',
                0,
                '1900-01-01',
                '{genero}',
                '{autor}',
                ''
            ) RETURNING id_livro;
        """

        resp_insert = self.operador_banco_dados.executa_insert(
            query_insert,
            return_id = True
        )
        if resp_insert['status'] != 200:
            return resp_insert

        id_inserido = int(self.operador_banco_dados.id_inserido)

        return {
            'status': 200,
            'mensagem': 'Livro cadastrado com sucesso.',
            'id_livro': id_inserido
        }

    def __remove_livro_banco_dados(self, id_livro: int) -> dict:
        query_delete = f"""
            DELETE FROM livro
            WHERE id_livro = {id_livro};
        """
        resp_delete = self.operador_banco_dados.executa_delete(query_delete)

        return resp_delete

    def __atualiza_livro_banco_dados(
        self,
        id_livro: int,
        nome: str,
        # qtd_paginas: int,
        # data_publicacao: str,
        genero: str,
        autor: str,
        # resumo: str
    ) -> dict:
        resp_livro_existente = self.__obtem_infos_livro_individual(id_livro)
        if resp_livro_existente['status'] != 200:
            return resp_livro_existente

        query_update = f"""
            UPDATE livro
            SET
                nome = '{nome}',
                genero = '{genero}',
                autor = '{autor}'
            WHERE id_livro = {id_livro};
        """
        resp_update = self.operador_banco_dados.executa_update(query_update)

        if resp_update['status'] != 200:
            return resp_update

        return {
            'status': 200,
            'mensagem': 'Livro atualizado com sucesso.'
        }

    def __obtem_info_criptografada(self, id_livro: int, campo: str) -> dict:
        query_select = f"""
            SELECT
                {campo}
            FROM livro
            WHERE id_livro = {id_livro};
        """
        response_qry = self.operador_banco_dados.executa_select(query_select)

        if response_qry['status'] != 200:
            return response_qry

        df_campo = self.operador_banco_dados.df_consulta

        if df_campo.empty:
            return {
                'status': 404,
                'mensagem': 'Campo não encontrado.'
            }

        valor_campo = df_campo.iloc[0, 0]

        return {
            'status': 200,
            'info': valor_campo
        }

    def listar_livros(self) -> dict:
        """Lista todos os livros cadastrados no sistema.

        Returns:
            dict: dict com a lista de livros.
        """
        response_livros = self.__obtem_livros_cadastrados()
        if response_livros['status'] != 200:
            return response_livros

        livros = []
        for seq, idx in enumerate(response_livros['livros'].index):
            df_livro_atual = response_livros['livros'].iloc[[seq]]
            livro = Livro()
            livro.inicializa_from_dataframe(df_livro_atual, idx)
            livros.append(livro.to_dict())

        return {
            'status': 200,
            'livros': livros
        }

    def obtem_infos_livro_individual(self, id_livro: int) -> dict:
        """Busca um livro pelo seu ID no sistema.

        Args:
            id_livro (int): id do livro a ser consultado.

        Returns:
            dict: dict com infos do livro, Not Found (404) caso contrário.
        """
        resp_obter_infos = self.__obtem_infos_livro_individual(id_livro)
        if resp_obter_infos['status'] != 200:
            return resp_obter_infos

        livro = Livro()
        livro.inicializa_from_dataframe(resp_obter_infos['livro'])

        return {
            'status': 200,
            'livro': livro.to_dict()
        }

    def cadastrar_livro(self, json_body: dict) -> dict:
        """Cadastra um novo livro no sistema.

        Args:
            json_body (dict): corpo da requisição.

        Returns:
            dict: dicionário com o id do livro cadastrado.
        """
        resp_cadastro = self.__cadastra_livro_banco_dados(
            nome = json_body['titulo'],
            # qtd_paginas = json_body['qtd_paginas'],
            # data_publicacao = json_body['data_publicacao'],
            genero = json_body['genero'],
            autor = json_body['autor']
            # resumo = json_body.get('resumo', '')
        )
        return resp_cadastro

    def remove_livro(self, id_livro: int) -> dict:
        """Remove um livro do sistema.

        Args:
            id_livro (int): id do livro a ser removido.
        """
        response_delete = self.__remove_livro_banco_dados(id_livro)
        if response_delete['status'] != 200:
            return response_delete

        return {
            'status': 200,
            'mensagem': 'Livro removido com sucesso.'
        }

    def atualiza_livro_completo(self, id_livro: int, json_body: dict) -> dict:
        """Atualiza um livro no sistema.

        Args:
            id_livro (int): id do livro a ser atualizado.
            json_body (dict): corpo da requisição.

        Returns:
            dict: dicionário com a mensagem de sucesso.
        """
        resp_atualizacao = self.__atualiza_livro_banco_dados(
            id_livro = id_livro,
            nome = json_body['titulo'],
            # qtd_paginas = json_body['qtd_paginas'],
            # data_publicacao = json_body['data_publicacao'],
            genero = json_body['genero'],
            autor = json_body['autor'],
            # resumo = json_body.get('resumo', '')
        )
        return resp_atualizacao

    def descriptografa_nome_campo(self, json_body):
        """Descriptografa a informação contida no campo 'campo' do json_body
            utilizando a chave pública do cliente.
        
        Args:
            json_body (dict): corpo da requisição.
        """
        if 'campo' not in json_body:
            return {
                'status': 400,
                'mensagem': 'Campo "campo" não encontrado no corpo da requisição.'
            }

        str_url64_encripted_data = str(json_body['campo'])

        # converte para bytes a informação encriptada
        bytes_encripted_data = urlsafe_b64decode(str_url64_encripted_data)
        # bytes_encripted_data = str_url64_encripted_data.encode('utf-8')

        # carrega a chave privada do servidor em cryptography/server_private.pem
        with open('cryptography/server_private.pem', 'rb') as file:
            server_private_key = serialization.load_pem_private_key(
                file.read(),
                password = None
            )

        print(f"Dados encriptados: {bytes_encripted_data}")

        # descriptografa a informação encripted_data
        decrypted_data = server_private_key.decrypt(
            bytes_encripted_data,
            padding.OAEP(
                mgf = padding.MGF1(algorithm = hashes.SHA256()),
                algorithm = hashes.SHA256(),
                label = None
            )
        )
        str_decrypted_data = decrypted_data.decode('utf-8')

        print(f"campo decriptado: {str_decrypted_data}")

        return {
            'status': 200,
            'campo': str_decrypted_data
        }

    def obtem_info_criptografada(self, id_livro: int, campo: str) -> dict:
        resp_obtem_info_especifica = self.__obtem_info_criptografada(id_livro, campo)

        if resp_obtem_info_especifica['status'] != 200:
            return resp_obtem_info_especifica

        # carrega a chave publica do cliente em cryptography/client_public.pem
        with open('cryptography/client_public.pem', 'rb') as file:
            client_public_key = serialization.load_pem_public_key(
                file.read()
            )

        info_campo = str(resp_obtem_info_especifica['info'])
        print(f"info_campo: {info_campo}")
        # encripta a informação obtida em resp_obtem_info_especifica['info']
        byte_encrypted_data = client_public_key.encrypt(
            info_campo.encode('utf-8'),
            padding.OAEP(
                mgf = padding.MGF1(algorithm = hashes.SHA256()),
                algorithm = hashes.SHA256(),
                label = None
            )
        )
        str_url64_encrypted_data = urlsafe_b64encode(byte_encrypted_data).decode('utf-8')
        print(str_url64_encrypted_data)
        return {
            'status': 200,
            'campo': str_url64_encrypted_data
        }

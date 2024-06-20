from operators.operador_banco_dados import OperadorBancoDados
from src.models.livro import Livro


class LivroService:
    def __init__(self):
        self.operador_banco_dados = OperadorBancoDados()

    def __obtem_livros_cadastrados(self) -> dict:
        query_select = "SELECT * FROM livro;"
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
            SELECT * FROM livro
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
        qtd_paginas: int,
        data_publicacao: str,
        genero: str,
        autor: str,
        resumo: str
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
                {qtd_paginas},
                '{data_publicacao}',
                '{genero}',
                '{autor}',
                '{resumo}'
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
            nome = json_body['nome'],
            qtd_paginas = json_body['qtd_paginas'],
            data_publicacao = json_body['data_publicacao'],
            genero = json_body['genero'],
            autor = json_body['autor'],
            resumo = json_body.get('resumo', '')
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

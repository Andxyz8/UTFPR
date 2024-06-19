from operators.operador_banco_dados import OperadorBancoDados


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
            'livros': df_livros.to_dict(orient='records')
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

    def listar_livros(self) -> dict:
        response_livros = self.__obtem_livros_cadastrados()

        return response_livros

    def obtem_infos_livro_individual(self, id_livro: int) -> dict:
        query_select = f"SELECT * FROM livro WHERE id_livro = {id_livro};"
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
            'livro': list(df_livro.to_dict(orient = 'records'))[0]
        }

    def cadastrar_livro(self, json_body: dict) -> dict:
        resp_cadastro = self.__cadastra_livro_banco_dados(
            nome = json_body['nome'],
            qtd_paginas = json_body['qtd_paginas'],
            data_publicacao = json_body['data_publicacao'],
            genero = json_body['genero'],
            autor = json_body['autor'],
            resumo = json_body.get('resumo', '')
        )
        return resp_cadastro

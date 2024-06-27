"""Módulo que contém a classe BancoDados que permite a conexão com um banco de dados.

Imports:
    os.getenv: útil para obter variáveis de ambiente.
    psycopg2.connect: permite a conexão com o banco de dados.
    pandas.DataFrame: estrutura de dados tabular bidimensional
        como suporte no processamento de dados.
"""
from os import getenv as os_getenv
from psycopg2 import connect
from pandas import DataFrame


class DatabaseOperator:
    """Classe que representa uma conexão com um banco de dados.

    Conexões que podem ser estabelecidas:
        teste_database: banco de dados de teste local.

    Atributos:
        df_consulta (DataFrame): dados de consultas realizadas.
        __database (str): define o banco de dados da conexão.
        __conexao_banco (Connection): objeto que representa a conexão.
        __cursor_banco (Cursor): objeto que permite operar no banco.

    Methods:
        - `operacao_sem_commit(funcao_banco):`
            - Decorador para operações que não precisam fazer commit das alterações.

        - `operacao_com_commit(funcao_banco):`
            - Decorador para operações que precisam fazer commit das alterações.

        - `__executa_insert_retorna_id(query_insert):`
            - Executa um INSERT no banco retornando o id do registro inserido.

        - `__executa_query(query):`
            - Executa uma query no banco.

        - `resultado_consulta_to_dataframe():`
            - Retorna os valores obtidos na consulta em um DataFrame.

        - `commita_alteracoes():`
            - Commita modificações da conexão atual.

        - `fecha_conexao():`
            - Fecha a conexão com o banco de dados.

        - `abre_conexao():`
            - Abre a conexão com o banco de dados especificado no momento da instanciação
                do objeto desta classe

        - `executa_select(query_select):`
            - Permite executar um SELECT no banco de dados.

        - `executa_insert(query_insert, return_id = False):`
            - Permite executar um INSERT no banco de dados.

        - `executa_update(query_update):`
            - Permite executar um UPDATE no banco de dados.

        - `executa_delete(query_delete):`
            - Permite executar um DELETE no banco de dados.
    """

    def __init__(self, database = 'teste_database'):
        """Instancia um objeto da classe BancoDados que permite fazer operações com o
            banco de dados especificado.

        Args:
            database (str, optional): banco para estabelecer a conexao. Default: 'geral'.

        Conexões possíveis de serem estabelecidas:
            - app_corretores: banco de dados do aplicativo dos corretores.
            - geral: banco geral da bairru.
            - mega: banco de dados do vimob.
        """
        self.df_consulta = None
        self.inserted_id = None
        self.__database = database
        self.__conexao_banco = None
        self.__cursor_banco = None

    # pylint: disable=W0718
    @staticmethod
    def operacao_sem_commit(funcao_banco):
        """Decorator que permite a uma função executar uma query no banco de dados e retornar
            as informações obtidas em um DataFrame sem fazer commit das alterações.
        """
        def executa_operacao_banco(self, *args, **kwargs) -> dict:
            try:
                self.abre_conexao()
                response = funcao_banco(self, *args, **kwargs)
            except Exception as excpt:
                self.fecha_conexao()
                return {
                    'status': 500,
                    'mensagem': f" [X] ERRO: {str(excpt)}"
                }

            self.resultado_consulta_to_dataframe()
            self.fecha_conexao()

            return response

        return executa_operacao_banco

    @staticmethod
    def operacao_com_commit(funcao_banco):
        """Decorator que permite a uma função executar uma query no banco de dados e retornar
            o id do registro inserido ou None caso não seja necessário retornar o id do registro.
        """
        def executa_operacao_banco(self, *args, **kwargs):
            try:
                self.abre_conexao()
                response = funcao_banco(self, *args, **kwargs)
            except Exception as excpt:
                self.fecha_conexao()
                return {
                    'status': 500,
                    'mensagem': f" [X] ERRO: {str(excpt)}"
                }

            self.commita_alteracoes()
            self.fecha_conexao()

            return response

        return executa_operacao_banco
    # pylint: enable=W0718

    def __executa_insert_retorna_id(self, query_insert):
        """Executa um INSERT no banco retornando o id do registro inserido.

        Args:
            query_insert (str): INSERT a ser executado.
        """
        # Executa o insert no banco de dados
        self.__executa_query(query_insert)

        # Define id do registro inserido como o valor da consulta da ultima query
        self.resultado_consulta_to_dataframe()

        # Define o id do registro inserido
        self.inserted_id = self.df_consulta.iloc[0, 0]

    def __executa_query(self, query) -> None:
        """Executa uma query no banco.

        Args:
            query (str): query a ser executada.
        """
        print(f"EXECUTANDO QUERY: {query}")
        self.__cursor_banco.execute(query)

    def resultado_consulta_to_dataframe(self):
        """Retorna os valores obtidos na consulta em um DataFrame.

        Returns:
            DataFrame: registros obtidos com a consulta.
        """
        self.df_consulta = DataFrame(
            data = self.__cursor_banco.fetchall(),
            columns = [column_name[0] for column_name in self.__cursor_banco.description]
        )

    def commita_alteracoes(self):
        """Commita modificações da conexão atual.
        """
        self.__conexao_banco.commit()

    def fecha_conexao(self) -> None:
        """Fecha a conexão com o banco de dados.
        """
        self.__cursor_banco.close()
        self.__conexao_banco.close()

    def abre_conexao(self) -> None:
        """Abre a conexão com o banco de dados especificado no momento da instanciação
            do objeto desta classe

        Raises:
            NotImplementedError: Disparada caso a conexão com o banco especificado
                não tenha sido implementada.
        """
        if self.__database == 'teste_database':
            self.__conexao_banco = connect(
                dbname = os_getenv("teste_database"),
                user = os_getenv("teste_login"),
                password = os_getenv("teste_senha"),
                host = os_getenv("teste_host"),
                port = os_getenv("teste_port")
            )
        else:
            raise NotImplementedError

        self.__cursor_banco = self.__conexao_banco.cursor()

    @operacao_sem_commit
    def executa_select(self, query_select) -> dict:
        """Permite executar um SELECT no banco de dados.

        Args:
            query_select (str): select a ser executado.
        
        Returns:
            dict: status da operação.
        """
        self.__executa_query(query_select)
        return {
            'status': 200
        }

    @operacao_com_commit
    def executa_insert(self, query_insert, return_id = False) -> dict:
        """Permite executar um INSERT no banco de dados.

        Args:
            query_insert (str): insert a ser executado.
        """
        if return_id:
            self.__executa_insert_retorna_id(query_insert)
        else:
            self.__executa_query(query_insert)

        return {
            'status': 200
        }

    @operacao_com_commit
    def executa_update(self, query_update) -> dict:
        """Permite executar um UPDATE no banco de dados.

        Args:
            query_update (str): update a ser executado.
        """
        self.__executa_query(query_update)

        return {
            'status': 200
        }

    @operacao_com_commit
    def executa_delete(self, query_delete) -> dict:
        """Permite executar um DELETE no banco de dados.

        Args:
            query_delete (str): delete a ser executado.
        """
        self.__executa_query(query_delete)

        return {
            'status': 200
        }

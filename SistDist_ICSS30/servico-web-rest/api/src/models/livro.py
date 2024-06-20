from pandas import DataFrame
from utils.operacoes_datetime import date_para_str_date


class Livro:

    def __init__(self):
        self.__id_livro = None
        self.__nome = None
        self.__qtd_paginas = None
        self.__data_publicacao = None
        self.__genero = None
        self.__autor = None
        self.__resumo = None

    def __str__(self):
        return f"""
            ID: {self.__id_livro}
            Nome: {self.__nome}
            Quantidade de Páginas: {self.__qtd_paginas}
            Data de Publicação: {self.__data_publicacao}
            Gênero: {self.__genero}
            Autor: {self.__autor}
            Resumo: {self.__resumo}
        """

    def __repr__(self):
        return f"""
            ID: {self.__id_livro}
            Nome: {self.__nome}
            Quantidade de Páginas: {self.__qtd_paginas}
            Data de Publicação: {self.__data_publicacao}
            Gênero: {self.__genero}
            Autor: {self.__autor}
            Resumo: {self.__resumo}
        """

    def __eq__(self, livro):
        return (
            self.__nome == livro.nome
            and self.__qtd_paginas == livro.qtd_paginas
            and self.__data_publicacao == livro.data_publicacao
            and self.__genero == livro.genero
            and self.__autor == livro.autor
            and self.__resumo == livro.resumo
        )

    def __ne__(self, livro):
        return not self.__eq__(livro)

    @property
    def id_livro(self) -> int:
        """Returns:
            int: id do livro.
        """
        return self.__id_livro

    @property
    def nome(self) -> str:
        """Returns:
            str: nome do livro.
        """
        return self.__nome

    @property
    def qtd_paginas(self) -> int:
        """Returns:
            int: quantidade de páginas.
        """
        return self.__qtd_paginas

    @property
    def data_publicacao(self) -> str:
        """Returns:
            str: data de publicação no formato YYYY-MM-DD.
        """
        return self.__data_publicacao

    def __obtem_data_publicacao(self, data_publicacao) -> str:
        """Formata a data de publicação para o formato YYYY-MM-DD.

        Args:
            data_publicacao (str): data de publicação em date.

        Returns:
            str: data de publicação no formato YYYY-MM-DD.
        """
        return date_para_str_date(data_publicacao) 

    @property
    def genero(self) -> str:
        """Returns:
            str: gênero do livro.
        """
        return self.__genero

    @property
    def autor(self) -> str:
        """Returns:
            str: nome do autor do livro.
        """
        return self.__autor

    @property
    def resumo(self) -> str:
        """Returns:
            str: resumo do livro.
        """
        return self.__resumo

    def inicializa_from_dataframe(self, df_livro: DataFrame, idx: int = 0) -> None:
        """Inicializa as propriedades do livro a partir de um DataFrame.

        Args:
            df_livro (DataFrame): DataFrame com as propriedades do livro.
            idx (int): índice do DataFrame a ser utilizado. Default: 0.
        """
        self.__id_livro = int(df_livro.at[idx, 'id_livro'])
        self.__nome = df_livro.at[idx, 'nome']
        self.__qtd_paginas = int(df_livro.at[idx, 'qtd_paginas'])
        self.__data_publicacao = self.__obtem_data_publicacao(
            df_livro.at[idx, 'data_publicacao']
        )
        self.__genero = df_livro.at[idx, 'genero']
        self.__autor = df_livro.at[idx, 'autor']
        self.__resumo = df_livro.at[idx, 'resumo']

    def to_dict(self) -> dict:
        """Transforma o livro com todas as suas propriedades em um dict.

        Returns:
            dict: dicionário com as propriedades do livro.
        """
        return {
            'id_livro': self.id_livro,
            'nome': self.nome,
            'qtd_paginas': self.qtd_paginas,
            'data_publicacao': self.data_publicacao,
            'genero': self.genero,
            'autor': self.autor,
            'resumo': self.resumo
        }

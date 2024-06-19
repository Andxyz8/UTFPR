from flask import request, make_response
from flask_classful import FlaskView, route
from traceback import format_exc
from src.livro.service.livro_service import LivroService
from utils.rota_base import RotaBase


class LivroController(FlaskView, RotaBase):
    route_base = '/livros/'

    def __init__(self):
        super().__init__()
        self._campos_obrigatorios = [
            'nome',
            'qtd_paginas',
            'data_publicacao',
            'genero',
            'autor'
        ]
        self.svc_livro = LivroService()

    @route('/', methods = ['GET'])
    def listagem_todos_livros(self):
        """Retorna a lista de livros cadastrados no sistema.

        Returns:
            dict: dicionário com a lista de livros.
        """
        resp_listagem = self.svc_livro.listar_livros()

        status_code = resp_listagem.pop('status')
        if status_code != 200:
            return make_response(resp_listagem, status_code)

        return make_response(resp_listagem, 200)

    @route('/', methods = ['POST'])
    def cadastra_livro(self):
        """Cadastra um novo livro no sistema.

        Body:
            {
	            "nome": str
	            "resumo": str (opcional)
	            "qtd_paginas": int
	            "data_publicacao": str
	            "genero": str
	            "autor": str
            }

        Returns:
            dict: dicionário com o id do livro cadastrado.
        """
        try:
            json_body = request.get_json()

            resp_verificacao = self._verifica_corpo_requisicao(json_body)
            status_code = resp_verificacao.pop('status')
            if status_code != 200:
                return make_response(resp_verificacao, status_code)

            resp_cadastrar = self.svc_livro.cadastrar_livro(json_body)
            status_code = resp_cadastrar.pop('status')
            if status_code != 200:
                return make_response(resp_cadastrar, status_code)

        except Exception as e:
            excecao_formatada = format_exc()
            response = {
                'mensagem': 'Erro interno no servidor.',
                'erro': str(e),
                'traceback': excecao_formatada
            }
            return make_response(response, 500)
        return make_response(resp_cadastrar, 201)

    @route('/<int:id_livro>', methods = ['GET'])
    def obtem_infos_livro_individual(self, id_livro: int):
        """Obtém as informações de um livro específico.

        Args:
            id_livro (int): id do livro a ser consultado.

        Returns:
            dict: dicionário contendo informações do livro.
        """
        response = self.svc_livro.obtem_infos_livro_individual(id_livro)

        status_code = response.pop('status')
        if status_code != 200:
            return make_response(response, status_code)

        return make_response(response['livro'], 200)

from flask import Flask
from src.livro.view.livro_controller import LivroController


def register_routes(app_server: Flask) -> None:
    """Método utilitário para registrar as rotas da aplicação
        no objeto do servidor Flask.

    Args:
        app_server (Flask): objeto do servidor Flask.
    """
    LivroController.register(app_server, route_base='/livros')

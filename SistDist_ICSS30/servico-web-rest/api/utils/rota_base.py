"""Módulo com a classe base para as rotas da API.
"""


class RotaBase:

    def __init__(self) -> None:
        self._campos_obrigatorios = []

    def _verifica_corpo_requisicao(self, campos_corpo_req: list) -> dict:
        """Verifica se o corpo da requisição possui os campos obrigatórios.

        Args:
            campos_corpo_req (dict): campos presentes no corpo da requisição.

        Returns:
            dict: dicionário com o status da verificação.
        """
        campos_faltantes = [
            campo for campo in self._campos_obrigatorios
                if campo not in campos_corpo_req
        ]

        if campos_faltantes:
            return {
                'status': 400,
                'mensagem': (
                    "Campos obrigatórios faltantes no corpo da requisição: "
                    f"{', '.join(campos_faltantes)}"
                    "."
                )
            }

        return {
            'status': 200
        }

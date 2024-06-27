

class BaseView:

    def __init__(self) -> None:
        self._needed_fields = []

    def _verifica_corpo_requisicao(self, request_body_fields: list) -> dict:
        """Verifyes if the request body has the required fields.

        Args:
            request_body_fields (dict): fields present in the body request.

        Returns:
            dict: dictionary with the verification status.
        """
        missing_fields = [
            missing_field for missing_field in self._needed_fields
                if missing_field not in request_body_fields
        ]

        if missing_fields:
            return {
                'status': 400,
                'message': (
                    "Needed fields are missing in the request body: "
                    f"{', '.join(missing_fields)}"
                    "."
                )
            }

        return {
            'status': 200
        }

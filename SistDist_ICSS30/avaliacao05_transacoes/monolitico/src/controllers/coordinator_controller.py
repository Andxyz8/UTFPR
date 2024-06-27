from flask import request
from flask_classful import FlaskView, route, make_response
from src.services.coordinator_service import CoordinatorService


class CoordinatorController(FlaskView):

    route_base = "/transaction"

    def __init__(self) -> None:
        self.svc_coordinator = CoordinatorService()

    @route('/', methods = ['POST'])
    def start_transaction(self):
        try:
            response = self.svc_coordinator.start_transaction()

            if response['status'] != 200:
                return response

            response = make_response(
                {
                    'txid': response['id_transaction']
                },
                201
            )
        except Exception as e:
            response = make_response(
                {
                    'message': str(e)
                },
                400
            )
        return response

    @route('/<int:id_transaction>', methods = ['PATCH'])
    def continue_transaction(self, id_transaction):
        try:
            json_request = request.get_json()

            response = self.svc_coordinator.continue_transaction(
                id_transaction,
                json_request
            )

            if response['status'] != 200:
                return response

            response = make_response(
                {
                    'message': 'Transaction updated successfully.'
                },
                200
            )
        except Exception as e:
            response = make_response(
                {
                    'message': str(e)
                },
                400
            )
        return response

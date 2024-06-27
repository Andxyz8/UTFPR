from flask import request
from flask_classful import FlaskView, route, make_response
from src.services.product_service import ProductService
from src.utils.base_view import BaseView

class ProductController(FlaskView, BaseView):

    route_base = '/product'

    def __init__(self):
        super().__init__()
        self._needed_fields = [
            'title',
            'price',
            'remaining_in_stock',
            'description',
            'min_remaining_for_stock_reposition'
        ]
        self.svc_product = ProductService()

    @route('/', methods = ['GET'])
    def get_products(self):
        try:
            response_service = self.svc_product.list_products()
            status_code = response_service.pop("status")
            response = make_response(
                response_service,
                status_code
            )
        except Exception as e:
            response = make_response(
                {
                    'message': str(e)
                },
                400
            )
        return response

    @route('/', methods = ['POST'])
    def create_product(self):
        try:
            json_request = request.get_json()

            resp_fields = self._verifica_corpo_requisicao(
                json_request.keys()
            )
            if resp_fields['status'] != 200:
                status_code = resp_fields.pop("status")
                response = make_response(
                    resp_fields,
                    status_code
                )
                return response

            response_service = self.svc_product.create_product(
                json_request
            )
            response = make_response(
                response_service,
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

    @route('/<int:id_product>', methods = ['GET'])
    def get_product(self, id_product: int):
        try:
            response_service = self.svc_product.get_product(id_product)
            if response_service['status'] != 200:
                return response_service

            status_code = response_service.pop("status")
            response = make_response(
                response_service,
                status_code
            )
        except Exception as e:
            response = make_response(
                {
                    'message': str(e)
                },
                400
            )
        return response

    @route('/<int:id_product>', methods = ['PUT'])
    def update_product(self, id_product: int):
        try:
            json_request = request.get_json()

            resp_fields = self._verifica_corpo_requisicao(
                json_request.keys()
            )
            if resp_fields['status'] != 200:
                status_code = resp_fields.pop("status")
                response = make_response(
                    resp_fields,
                    status_code
                )
                return response

            response_service = self.svc_product.update_product(
                id_product,
                json_request
            )
            response = make_response(
                response_service,
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

    @route('/<int:id_product>', methods = ['DELETE'])
    def delete_product(self, id_product: int):
        try:
            response_service = self.svc_product.delete_product(id_product)
            if response_service['status'] == 200:
                return response_service

            status_code = response_service.pop("status")
            response = make_response(
                {
                    'message': f"Product {id_product} deleted."
                },
                status_code
            )
        except Exception as e:
            response = make_response(
                {
                    'message': str(e)
                },
                400
            )
        return response

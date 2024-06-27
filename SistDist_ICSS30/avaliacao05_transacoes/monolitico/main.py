from flask import Flask
from flask_cors import CORS
from src.controllers.order_controller import OrderController
from src.controllers.product_controller import ProductController

APP = Flask(__name__)

CORS(APP)

ProductController.register(APP, route_base = '/product')
OrderController.register(APP, route_base = '/order')

if __name__ == '__main__':
    APP.run(
        host = "0.0.0.0",
        port = 5000,
        debug = True
    )

from flask import Flask
from flask_cors import CORS
from src.routes import register_routes


APP = Flask(__name__)


if __name__ == '__main__':
    register_routes(APP)

    CORS(app = APP)

    APP.run(debug = True)

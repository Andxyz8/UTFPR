from flask import Flask
from flask_cors import CORS
from src.routes import register_routes


APP = Flask(__name__)


if __name__ == '__main__':
    CORS(app = APP, resources={r"/*": {"origins": "http://192.168.15.7:8080"}})

    register_routes(APP)
    APP.run(host='0.0.0.0', debug = True)

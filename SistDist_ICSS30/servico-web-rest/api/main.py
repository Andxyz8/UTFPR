from flask import Flask
from src.routes import register_routes
from flask_cors import CORS 


APP = Flask(__name__)


if __name__ == '__main__':
    register_routes(APP)

    CORS(APP)

    APP.run(debug = True)

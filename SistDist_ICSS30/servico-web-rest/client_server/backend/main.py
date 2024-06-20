from flask import Flask, jsonify, request 
from flask_cors import CORS
import uuid

app = Flask(__name__)

app.config.from_object(__name__)

CORS(app, resources={r"/*":{'origins':"*"}})

LIVROS = [

    {   'id': uuid.uuid4().hex,
        'title':'Game of Thrones',
        'genre':'Ficção',
        'author': 'George R. R. Martin',
    },
]

# The GET and POST route handler
@app.route('/livros', methods=['GET', 'POST'])
def all_livros():
    response_object = {'status':'success'}
    if request.method == "POST":
        post_data = request.get_json()
        LIVROS.append({
            'id' : uuid.uuid4().hex,
            'title': post_data.get('title'),
            'genre': post_data.get('genre'),
            'author': post_data.get('author')})
        response_object['message'] =  'Game Added!'
    else:
        response_object['livros'] = LIVROS
    return jsonify(response_object)


#The PUT and DELETE route handler
@app.route('/livros/<game_id>', methods =['PUT', 'DELETE'])
def single_game(game_id):
    response_object = {'status':'success'}
    if request.method == "PUT":
        post_data = request.get_json()
        remove_game(game_id)
        LIVROS.append({
            'id' : uuid.uuid4().hex,
            'title': post_data.get('title'),
            'genre': post_data.get('genre'),
            'played': post_data.get('played')
        })
        response_object['message'] =  'Game Updated!'
    if request.method == "DELETE":
        remove_game(game_id)
        response_object['message'] = 'Game removed!'    
    return jsonify(response_object)


# Removing the game to update / delete
def remove_game(game_id):
    for game in LIVROS:
        if game['id'] == game_id:
            LIVROS.remove(game)
            return True
    return False

if __name__ == "__main__":
    app.run(debug=True)


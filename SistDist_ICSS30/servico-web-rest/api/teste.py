from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from base64 import urlsafe_b64encode
import requests


# carrega a chave publica do servidor
with open('cryptography/server_public.pem', 'rb') as f:
    server_public_key = serialization.load_pem_public_key(
        f.read()
    )

# encripta a informação da variavel campo
campo = b'qtd_paginas'

encrypted_data = server_public_key.encrypt(
    campo,
    padding.OAEP(
        mgf = padding.MGF1(algorithm = hashes.SHA256()),
        algorithm = hashes.SHA256(),
        label = None
    )
)

print(f"Dados encriptados: {encrypted_data}")

str_url64_encrypted_data = urlsafe_b64encode(encrypted_data).decode('utf-8')

print(f"Dados encriptados: {str_url64_encrypted_data}")
# faz uma requisição na rota /livro/4/info-criptografada com os dados de um json {'campo': encrypted_data.decode('utf-8')}
# e imprime a resposta
resposta = requests.get(
    'http://localhost:5000/livros/6/info-criptografada',
    json = {'campo': str_url64_encrypted_data}
)
print(resposta.json())

from hashlib import sha1

def calcula_hash(dados_arquivo: bytes) -> str:
    """Calcula o hash de um arquivo.
    
    Args:
        dados_arquivo (bytes): dados do arquivo.
    """
    obj_hash = sha1()

    # obtem o hash do arquivo recebido
    obj_hash.update(dados_arquivo)

    # Retorna o hash como string
    return obj_hash.hexdigest()

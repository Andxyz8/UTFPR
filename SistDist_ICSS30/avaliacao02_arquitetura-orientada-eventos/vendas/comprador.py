from pika import BlockingConnection, ConnectionParameters


def obtem_quantidade_estoque(produto: str) -> int:
    # if not os.path.exists(f'./estoque/produtos/{produto}.txt'):
        # return 0

    with open(f'./estoque/produtos/{produto}.txt', mode = 'r', encoding = 'UTF-8') as arquivo:
        return int(arquivo.readline())

def main():
    connection = BlockingConnection(
        ConnectionParameters('localhost')
    )
    channel = connection.channel()

    channel.exchange_declare(
        exchange = 'fila_compras',
        exchange_type = 'fanout'
    )

    while resposta := input(" [x] Deseja comprar algo? (s/n) "):
        if resposta == 'n':
            break

        if resposta != 's':
            print(" [x] Resposta inválida.")
            break

        produto = input("Qual produto deseja comprar? ")
        quantidade = input("Quantas unidades? ")
        qtd_estoque = obtem_quantidade_estoque(produto)

        print(f" [x] Estoque atual de {produto}: {qtd_estoque}")

        if int(quantidade) > qtd_estoque:
            print(" [x] Estoque insuficiente.")
            break

        channel.basic_publish(
            exchange = 'fila_compras',
            routing_key = '',
            body = str(f"{produto}:{quantidade}:{qtd_estoque}")
        )

    print(" [x] Processo de compra encerrado.")
    connection.close()

if __name__ == '__main__':
    main()

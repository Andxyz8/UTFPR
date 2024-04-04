from sys import exit as sys_exit
from pika import BlockingConnection, ConnectionParameters

def main():
    connection = BlockingConnection(
        ConnectionParameters('localhost')
    )
    channel = connection.channel()

    channel.exchange_declare(
        exchange = 'fila_compras',
        exchange_type = 'fanout'
    )

    result = channel.queue_declare(
        queue = '',
        exclusive = True
    )
    queue_name = result.method.queue

    channel.queue_bind(
        exchange = 'fila_compras',
        queue = queue_name
    )

    def callback(ch, method, properties, body):
        # converte bytes para um dicionário
        print(f" [x] COMPRA EFETUADA! {body}")
        body = str(body).split(":")

        print(f" [x] Pedido: {body[0]} - {body[1]} unidades")

        # remove a quantia do estoque
        with open(f"./estoque/produtos/{body[0][2:]}.txt", 'w', encoding='UTF-8') as file:
            # escreve no arquivo do produto a nova quantidade em estoque
            file.write(str(int(body[2][:-1]) - int(body[1])))

        print(" [x] Pedido processado!")


    channel.basic_consume(
        queue = queue_name,
        auto_ack = True,
        on_message_callback = callback
    )

    print(' [*] Waiting for orders. To exit press CTRL+C')
    channel.start_consuming()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print(' [*] Exiting...')
        sys_exit(0)

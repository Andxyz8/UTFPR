from sys import exit as sys_exit
from pika import BlockingConnection, ConnectionParameters

def main():
    connection = BlockingConnection(
        ConnectionParameters('localhost')
    )
    channel_orders = connection.channel()
    channel_stock = connection.channel()

    channel_orders.exchange_declare(
        exchange = 'fila_compras',
        exchange_type = 'fanout'
    )

    channel_stock.queue_declare(
        queue = 'pedidos_estoque'
    )

    result = channel_orders.queue_declare(
        queue = '',
        exclusive = True
    )
    queue_name = result.method.queue

    channel_orders.queue_bind(
        exchange = 'fila_compras',
        queue = queue_name
    )

    def callback_pedido(ch, method, properties, body):
        print(f" [x] {body}")

        body = str(body).split(":")

        estoque_minimo = 5

        estoque_atual = int(body[2][:-1])

        if estoque_minimo > (estoque_atual - int(body[1])):
            print(" [x] Solicitando nova remessa aos fornecedores.")
            channel_stock.basic_publish(
                exchange = '',
                routing_key = 'pedidos_estoque',
                body = f"{body[0][2:]}:{estoque_atual}"
            )


    channel_orders.basic_consume(
        queue = queue_name,
        auto_ack = True,
        on_message_callback = callback_pedido
    )

    print(' [*] Waiting for order. To exit press CTRL+C')
    channel_orders.start_consuming()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print(' [*] Exiting...')
        sys_exit(0)

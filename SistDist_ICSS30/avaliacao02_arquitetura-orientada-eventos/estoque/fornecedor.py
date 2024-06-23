from sys import exit as sys_exit
from time import sleep as time_sleep
from random import randint
from pika import BlockingConnection, ConnectionParameters

def main():
    connection = BlockingConnection(
        ConnectionParameters('localhost')
    )
    channel = connection.channel()

    channel.queue_declare(queue='pedidos_estoque')

    def callback(ch, method, properties, body):
        print(f" [x] Received: {body}")

        body = str(body).split(':')

        tempo = (1/(int(body[1][:-1])))*35

        time_sleep(tempo)

        with (open(
                f'./estoque/produtos/{body[0][2:]}.txt',
                mode = 'w',
                encoding = 'UTF-8'
            ) as arquivo
        ):
            arquivo.write(str(int(body[1][:-1])+randint(25, 50)))

        print(" [x] Done")

        ch.basic_ack(delivery_tag = method.delivery_tag)

    channel.basic_qos(prefetch_count = 1)

    channel.basic_consume(
        queue = 'pedidos_estoque',
        auto_ack = False,
        on_message_callback = callback
    )

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print(' [*] Exiting...')
        sys_exit(0)

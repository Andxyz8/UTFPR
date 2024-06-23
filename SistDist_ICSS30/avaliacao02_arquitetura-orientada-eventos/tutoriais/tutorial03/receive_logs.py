from sys import exit as sys_exit
from pika import BlockingConnection, ConnectionParameters

def main():
    connection = BlockingConnection(
        ConnectionParameters('localhost')
    )
    channel = connection.channel()

    channel.exchange_declare(
        exchange = 'logs',
        exchange_type = 'fanout'
    )

    result = channel.queue_declare(
        queue = '',
        exclusive = True
    )
    queue_name = result.method.queue

    channel.queue_bind(
        exchange = 'logs',
        queue = queue_name
    )

    def callback(ch, method, properties, body):
        print(f" [x] {body}")


    channel.basic_consume(
        queue = queue_name,
        auto_ack = True,
        on_message_callback = callback
    )

    print(' [*] Waiting for logs. To exit press CTRL+C')
    channel.start_consuming()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print(' [*] Exiting...')
        sys_exit(0)

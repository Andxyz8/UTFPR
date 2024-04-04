from sys import exit as sys_exit
from time import sleep as time_sleep
from pika import BlockingConnection, ConnectionParameters

def main():
    connection = BlockingConnection(
        ConnectionParameters('localhost')
    )
    channel = connection.channel()

    channel.queue_declare(queue='hello')

    def callback(ch, method, properties, body):
        print(f" [x] Received: {body}")

        time_sleep(body.count(b'.'))

        print(" [x] Done")

        ch.basic_ack(delivery_tag = method.delivery_tag)

    channel.basic_qos(prefetch_count = 1)

    channel.basic_consume(
        queue = 'queue',
        auto_ack=False,
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

import pika
from sys import exit as sys_exit

def main():
    connection = pika.BlockingConnection(
        pika.ConnectionParameters('localhost')
    )
    channel = connection.channel()

    channel.queue_declare(queue='hello')

    def callback(ch, method, properties, body):
        print(f" [x] Received: {body}")

    channel.basic_consume(
        queue = 'hello',
        auto_ack = True,
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

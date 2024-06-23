import pika
import sys

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

channel.queue_declare(queue='hello')

if len(sys.argv) > 1:
    message = sys.argv[1]
else:
    message = 'Hello World!'

channel.basic_publish(
    exchange = '',
    routing_key = 'hello',
    body = message
)
print(f" [x] Sent {message}")

connection.close()

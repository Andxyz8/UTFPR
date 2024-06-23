from pika import BasicProperties, BlockingConnection, ConnectionParameters, DeliveryMode
import sys

connection = BlockingConnection(ConnectionParameters('localhost'))
channel = connection.channel()

channel.queue_declare(
    queue = 'queue',
    durable = True
)

if len(sys.argv) > 1:
    message = sys.argv[1]
else:
    message = 'Hello World!'

channel.basic_publish(
    exchange = '',
    routing_key = 'queue',
    body = message,
    properties = BasicProperties(
        delivery_mode = DeliveryMode.Persistent
    )
)

print(f" [x] Sent {message}")

connection.close()

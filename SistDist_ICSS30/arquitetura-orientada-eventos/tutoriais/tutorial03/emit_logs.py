import sys
from pika import BlockingConnection, ConnectionParameters

connection = BlockingConnection(ConnectionParameters('localhost'))
channel = connection.channel()

if len(sys.argv) > 1:
    message = sys.argv[1]
else:
    message = 'Hello World!'

channel.exchange_declare(
    exchange = 'logs',
    exchange_type = 'fanout'
)

channel.basic_publish(
    exchange = 'logs',
    routing_key = '',
    body = message
)

print(f" [x] Sent {message}")

connection.close()

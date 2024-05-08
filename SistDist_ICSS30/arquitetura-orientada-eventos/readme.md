# Arquitetura Orientada a Eventos

## Descrição Geral

- Desenvolver uma aplicação simples orientada a microsserviços.
- Em cada microsserviço deve ocorrer eventos que sejam de interesse de outros microsserviços.
- A comunicação entre os microsserviços será orientada a eventos.

## Requisitos

- Dois ou mais clientes publicadores devem gerar eventos (mensagens);

- Dois ou mais clientes consumidores ou assinantes devem registrar interesse em receber notificações de eventos;

- Utilizar o serviço de mensageria (message broker) RabbitMQ e o protocolo AMQP (Advanced Message Queuing Protocol) para permitir a comunicação indireta entre os processos clientes.
  - O broker é responsável por enviar notificações de eventos aos clientes assinantes interessados.

## Restante da Descrição da Atividade

### Tutoriais

Tutorial de clientes RabbitMQ disponível para várias linguagens:

- Python: <https://www.rabbitmq.com/tutorials/tutorial-one-python.html>

- Spring AMQP: <https://www.rabbitmq.com/tutorials/tutorial-one-spring-amqp.html>

- Ruby: <https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html>

- PHP: <https://www.rabbitmq.com/tutorials/tutorial-one-php.html>

- Java: <https://www.rabbitmq.com/tutorials/tutorial-one-java.html>

Obs.: vejam os tutoriais 1, 4 e 5.

### Tutorial 1

- Hello World.
- Conceito básicos: produtor, consumidor, exchange default (sem nome) e fila para armazenar mensagens.

### Tutorial 2

- Uma única fila de tarefas para distribuir tarefas entre vários trabalhadores.
- Cada tarefa é atribuída a um único trabalhador.
- Exemplifica o uso de confirmações (ack) de mensagens recebidas, persistência de filas e mensagens.

### Tutorial 3

- Publish/subscribe - entrega uma mensagem publicada para todos os consumidores utilizando broadcast.
- Exemplo de sistema de geração de logs, onde consumidores querem receber todas as mensagens de logs e não apenas um subconjunto delas.
- Explica o uso de uma exchange to tipo fanout para qual os publicadores enviam mensagens.
- Exchange fanout: entrega todas mensagens para todas as filas que conhece. Explica o binding entre exchange e fila.

### Tutorial 4

- Publish/subscribe - consumidores têm interesse apenas em um subconjunto de mensagens.
- Sistema de geração de logs, onde existem mensagens de log relacionadas à erro, warning e info.
- Consumidores especificam o tipo de log que desejam receber.
- Explica o uso da exchange direct, onde uma mensagem é entregue para as filas cuja binding key correspondem exatamente à routing key da mensagem.
- Uma fila pode ter uma ou mais bindings keys e um mesmo binding key pode estar atrelado a múltiplas filas.

### Tutorial 5

- Registrar interesse de mensagens com base em múltiplos critérios.
- Uso da exchange topic.
- Sistemas de geração de logs que permite registrar interesse não apenas em logs com base na sua severidade (info, erro, warning), mas também com base na fonte emissora do log.
- Uma mensagem enviada para uma exchange topic não podem ter uma routing_key arbitrária, elas deve ser uma lista de palavras (limite de 255 bytes) delimitadas por pontos, as quais especificam alguns recursos ligados à mensagem. A binding key também deve ter o mesmo formato.
- A lógica por trás da exchange topic é semelhante à exchange direct - uma mensagem enviada com uma routing key específica será entregue a todas as filas vinculadas a uma binding key correspondente. No entanto, existem dois casos especiais importantes para binding key: * pode substituir exatamente uma palavra; # pode substituir zero ou mais palavras. Quando esses caracteres não são utilizados nos bindings, uma exchange topic se comporta como uma exchange direct.

### Tutorial 6

- RPC (Remote Procedure Call) com RabbitMQ, uso de filas de callback.

### Tutorial 7

- Confirmação de publicações.

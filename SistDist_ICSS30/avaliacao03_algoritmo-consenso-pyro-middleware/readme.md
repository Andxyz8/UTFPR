# Middleware Pyro e Algoritmo de Consenso

## Descrição Geral

- Implementar o algoritmo de consenso Raft para replicação de log entre 4 processos que vão se comunicar através do Pyro.

- Inicialização dos processos:
  - Inicializem o servidor de nomes do Pyro;
  - Inicializem os 4 processos que implementam o Raft como seguidores;
- Informem uma porta ao criar o Daemon e um objectId no registro do objeto com o Daemon.
  - Com essas duas informações, teremos o URI "PYRO:objectId@localhost:porta" de cada objeto Pyro e poderemos deixá-los hard coded;
- Inicializem um processo cliente responsável por encaminhar comandos ao líder.

## Requisitos

### Eleição

- Um dos processos será eleito líder;
- Utilizem temporizadores de eleição aleatórios para evitar que os nós se tornem candidatos ao mesmo tempo;
- Quando um líder falhar, um outro processo será eleito como líder.

### Replicação

- O cliente pesquisará o URI do líder no servidor de nomes;
- O cliente enviará comandos ao líder;
- O líder será responsável por receber receber comandos dos clientes, anexá-los ao seu log e replicá-los aos seguidores;
- Uma entrada no log apenas será efetivada (committed) se a maioria dos seguidores confirmarem ela no seu log;
- O líder transmitirá mensagens periódicas para todos os seguidores para manter sua autoridade e prevenir novas eleições.
  - Obs.: o algoritmo não precisa lidar com partições de rede.

## Restante da Descrição da Atividade

### Funcionamento do Raft

- Slides 25 a 30 da aula Coordenação e Acordo.
- Visualização: <https://thesecretlivesofdata.com/raft/>
- Artigo: <https://www.cs.bu.edu/~jappavoo/jappavoo.github.com/451/papers/raft-extended.pdf>
- <https://web.stanford.edu/~ouster/cgi-bin/cs190-winter20/lecture.php?topic=raft>

### Tutoriais Pyro

- Diocumentação: <https://pyro5.readthedocs.io/en/latest/intro.html>

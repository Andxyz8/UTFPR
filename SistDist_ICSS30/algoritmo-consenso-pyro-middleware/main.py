import Pyro5.api
import Pyro5.server
from sys import argv
from raft_node import RaftNode


# Creates the daemon object
daemon = Pyro5.server.Daemon()

# Find the pyro nameserver
nameserver_pyro = Pyro5.api.locate_ns()

# use argv to pass the object_id
object_id_argv = argv[1]

this_raft_node = RaftNode(object_id = f'raft_node_{object_id_argv}')
this_raft_node.initialize_node(str(daemon.register(this_raft_node, this_raft_node.object_id)))
nameserver_pyro.register(this_raft_node.object_id, this_raft_node.uri)
this_raft_node.start_node()

objects_pyro = nameserver_pyro.list()
# print out the objects in the nameserver
print(objects_pyro)

daemon.requestLoop()
# # inicia thread em background para o loop do daemon do Pyro
# th_daemon = threading.Thread(target=daemon.requestLoop)
# th_daemon.daemon = True
# th_daemon.start()

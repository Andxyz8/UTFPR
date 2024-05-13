import Pyro5.api
import Pyro5.server
import threading
from raft_node import RaftNode


# raft_node_1 = RaftNode(object_id = 'raft_node_1')
# raft_node_1.initialize_node(str(daemon_raft_node1.register(raft_node_1, raft_node_1.object_id)))
# raft_node_1 = RaftNode(object_id = 'raft_node_1')
# raft_node_1.initialize_node(str(daemon_raft_node1.register(raft_node_1, raft_node_1.object_id)))
# raft_node_1 = RaftNode(object_id = 'raft_node_1')
# raft_node_1.initialize_node(str(daemon_raft_node1.register(raft_node_1, raft_node_1.object_id)))

# Creates the daemon object
daemon = Pyro5.server.Daemon()

# Find the pyro nameserver
nameserver_pyro = Pyro5.api.locate_ns()

dict_raft_nodes = {}
# for idx in range(1, 5):
this_raft_node = RaftNode(object_id = 'raft_node_1')
this_raft_node.initialize_node(str(daemon.register(this_raft_node, this_raft_node.object_id)))
nameserver_pyro.register(this_raft_node.object_id, this_raft_node.uri)
this_raft_node.start_node()

# print out the objects in the nameserver
print(nameserver_pyro.list())

# # inicia thread em background para o loop do daemon do Pyro
# th_daemon = threading.Thread(target=daemon.requestLoop)
# th_daemon.daemon = True
# th_daemon.start()

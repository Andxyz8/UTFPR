from sys import argv
import Pyro5.api
import Pyro5.server
from raft_node import RaftNode


# Creates the daemon object
daemon = Pyro5.server.Daemon()

# Find the pyro nameserver
nameserver_pyro = Pyro5.api.locate_ns()

# use argv to pass the object_id
OBJECT_ID_FROM_ARGS = argv[1]

# Create the raft node object
this_raft_node = RaftNode(object_id = f'raft_node_{OBJECT_ID_FROM_ARGS}')
this_raft_node.initialize_node(str(daemon.register(this_raft_node, this_raft_node.object_id)))
# Register the node in the nameserver
nameserver_pyro.register(this_raft_node.object_id, this_raft_node.uri)

# Start the node (internal, starts the election process)
this_raft_node.start_node()

objects_pyro = nameserver_pyro.list()

# print out the objects in the nameserver to see if the node is registered
print(objects_pyro)

daemon.requestLoop()

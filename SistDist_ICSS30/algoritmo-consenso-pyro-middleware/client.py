from Pyro5.api import Proxy
from raft_node import RaftNode


entrada = input("COMMAND: ")

node_raft_leader: RaftNode =  Proxy("PYRO:raft_node_1@DESKTOP-EA37V7A:9091")
node_raft_leader.receive_command(entrada)
print(node_raft_leader.peers)

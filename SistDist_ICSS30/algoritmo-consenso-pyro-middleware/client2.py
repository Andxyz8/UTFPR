import sys
import time
from embedded_server import hostname, nameserverDaemon
import Pyro5.api
import threading
from raft_node import RaftNode

# Create a RaftNode daemon
daemon_raft_node2 = Pyro5.api.Daemon(host = hostname, port = 9092)
raft_node_2 = RaftNode(object_id = 'raft_node_2')
raft_node_2.initialize_node(str(daemon_raft_node2.register(raft_node_2, raft_node_2.object_id)))
thread_raft_node2 = threading.Thread(target=daemon_raft_node2.requestLoop)
thread_raft_node2.daemon = True
# register it with the embedded nameserver
nameserverDaemon.nameserver.register("raft_node_2.server", raft_node_2.uri)

def start_node_2():
    try:
        while True:
            if not raft_node_2.active:
                nameserverDaemon.nameserver.register("raft_node_2", raft_node_2.uri)
                print("Starting raft_node_2...")
                thread_raft_node2.start()
                raft_node_2.start_node()
            time.sleep(0.4)
    except KeyboardInterrupt:
        print("Stopping the server...")
        sys.exit(0)

if __name__ == "__main__":
    start_node_2()
import sys
import time
from embedded_server import hostname, nameserverDaemon
import Pyro5.api
import threading
from raft_node import RaftNode

daemon_raft_node1 = Pyro5.api.Daemon(host = hostname, port = 9091)
raft_node_1 = RaftNode(object_id = 'raft_node_1')
raft_node_1.initialize_node(str(daemon_raft_node1.register(raft_node_1, raft_node_1.object_id)))
thread_raft_node1 = threading.Thread(target=daemon_raft_node1.requestLoop)
thread_raft_node1.daemon = True

def start_node_1():
    try:
        while True:
            if not raft_node_1.active:
                nameserverDaemon.nameserver.register("raft_node_1", raft_node_1.uri)
                print("Starting raft_node_1...")
                thread_raft_node1.start()
                raft_node_1.start_node()
            time.sleep(0.4)
    except KeyboardInterrupt:
        print("Stopping the server...")
        sys.exit(0)

if __name__ == "__main__":
    start_node_1()
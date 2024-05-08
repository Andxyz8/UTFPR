import threading
import socket
import select
import time
import Pyro5.socketutil
import Pyro5.api
from raft_node import RaftNode

Pyro5.config.SERVERTYPE = "thread"


hostname = socket.gethostname()
my_ip = Pyro5.socketutil.get_ip_address(None, workaround127=True)

print("THREADED server type. Initializing services...")
print("Make sure that you don't have a name server running already!\n")

# start a name server with broadcast server
nameserver_uri, nameserverDaemon, broadcastServer = Pyro5.nameserver.start_ns(host=my_ip)

assert broadcastServer is not None, "expect a broadcast server to be created"
print("got a Nameserver, uri = %s\n" % nameserver_uri)

# create a RaftNode daemon
daemon_raft_node1 = Pyro5.api.Daemon(host = hostname, port = 9091)
raft_node_1 = RaftNode(object_id = 'raft_node_1')
raft_node_1.initialize_node(str(daemon_raft_node1.register(raft_node_1, raft_node_1.object_id)))
thread_raft_node1 = threading.Thread(target=daemon_raft_node1.requestLoop)
thread_raft_node1.daemon = True
thread_raft_node1.start()
# register it with the embedded nameserver
nameserverDaemon.nameserver.register("raft_node_1", raft_node_1.uri)


# Create a RaftNode daemon
daemon_raft_node2 = Pyro5.api.Daemon(host = hostname, port = 9092)
raft_node_2 = RaftNode(object_id = 'raft_node_2')
raft_node_2.initialize_node(str(daemon_raft_node2.register(raft_node_2, raft_node_2.object_id)))
thread_raft_node2 = threading.Thread(target=daemon_raft_node2.requestLoop)
thread_raft_node2.daemon = True
thread_raft_node2.start()
# register it with the embedded nameserver
nameserverDaemon.nameserver.register("raft_node_2.server", raft_node_2.uri)


# Create a RaftNode daemon
daemon_raft_node3 = Pyro5.api.Daemon(host = hostname, port = 9093)
raft_node_3 = RaftNode(object_id = 'raft_node_3')
raft_node_3.initialize_node(str(daemon_raft_node3.register(raft_node_3, raft_node_3.object_id)))
thread_raft_node3 = threading.Thread(target=daemon_raft_node3.requestLoop)
thread_raft_node3.daemon = True
thread_raft_node3.start()
# register it with the embedded nameserver
nameserverDaemon.nameserver.register("raft_node_3.server", raft_node_3.uri)


# Create a RaftNode daemon
daemon_raft_node4 = Pyro5.api.Daemon(host = hostname, port = 9094)
raft_node_4 = RaftNode(object_id = 'raft_node_4')
raft_node_4.initialize_node(str(daemon_raft_node4.register(raft_node_4, raft_node_4.object_id)))
thread_raft_node2 = threading.Thread(target=daemon_raft_node4.requestLoop)
thread_raft_node2.daemon = True
thread_raft_node2.start()
# register it with the embedded nameserver
nameserverDaemon.nameserver.register("raft_node_4.server", raft_node_4.uri)


print(f"{raft_node_1.object_id} uri = {raft_node_1.uri}")
print(raft_node_1)
print(f"{raft_node_2.object_id} uri = {raft_node_2.uri}")
print(raft_node_2)
print(f"{raft_node_3.object_id} uri = {raft_node_3.uri}")
print(raft_node_3)
print(f"{raft_node_4.object_id} uri = {raft_node_4.uri}")
print(raft_node_4)

print("")

while True:
    print(time.asctime(), "Waiting for requests...")

    # print(raft_node_1)

    # create sets of the socket objects we will be waiting on
    # (a set provides fast lookup compared to a list)
    nameserverSockets = set(nameserverDaemon.sockets)
    sockets_raft_node1 = set(daemon_raft_node1.sockets)
    sockets_raft_node2 = set(daemon_raft_node2.sockets)
    rs = [broadcastServer]  # only the broadcast server is directly usable as a select() object
    rs.extend(nameserverSockets)
    rs.extend(sockets_raft_node1)
    rs.extend(sockets_raft_node2)
    rs, ws, _ = select.select(rs, [], [], 3)
    eventsForNameserver = []
    eventsForDaemon = []
    events_raft_node1 = []
    events_raft_node2 = []
    for s in rs:
        if s is broadcastServer:
            print("Broadcast server received a request")
            broadcastServer.processRequest()
        elif s in nameserverSockets:
            eventsForNameserver.append(s)
        elif s in sockets_raft_node1:
            events_raft_node1.append(s)
        elif s in sockets_raft_node2:
            events_raft_node2.append(s)

    if eventsForNameserver:
        print("Nameserver received a request")
        nameserverDaemon.events(eventsForNameserver)
    if events_raft_node1:
        print("RaftNode1 received a request")
        daemon_raft_node1.events(events_raft_node1)
    if events_raft_node2:
        print("RaftNode2 received a request")
        daemon_raft_node2.events(events_raft_node2)

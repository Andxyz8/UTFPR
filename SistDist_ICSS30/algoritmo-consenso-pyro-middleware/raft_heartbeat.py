import threading

class RaftHeartbeat:
    def __init__(self):
        self.leader_node = None
        self.node_heartbeat_timer = None
        self.start_heartbeat_timer()

    def send_heartbeat(self):
        """Send heartbeat to the leader node."""
        if self.leader_node:
            self.start_heartbeat_timer()
            self.leader_node.send_heartbeat()
        else:
            print("Leader node is not defined.")

    def start_heartbeat_timer(self):
        """Start the heartbeat timer."""
        self.node_heartbeat_timer = threading.Timer(1, self.send_heartbeat)
        self.node_heartbeat_timer.daemon = True
        self.node_heartbeat_timer.start()

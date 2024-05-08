"""Raft heartbeat module. Manages the heartbeat process.
"""
import threading
import Pyro5.api

class RaftHeartbeat:
    """Raft heartbeat class. Manages the heartbeat process.

    Methods:
        send_heartbeat: Send heartbeat to the leader node.
        send_followers_heartbeat: Send heartbeat to all followers.
        start_leader_heartbeats: Start the leader heartbeats.
    """

    def __init__(self):
        # heartbeat interval in milliseconds
        self.__HEARTBEAT_INTERVAL = 1000/1000
        self.leader_node = None
        self.node_heartbeat_timer = None

    def send_follower_to_leader_heartbeat(self, follower_uri: str):
        """Send heartbeat to the leader node."""
        if self.leader_node:
            self.leader_node.receive_follower_heartbeat(follower_uri)
        else:
            print("Leader node is not defined.")

    def send_followers_heartbeat(self):
        """Send heartbeat to all followers."""
        print(f"Sending heartbeat to all followers of node {self.leader_node.object_id}")
        # If have followers, send heartbeat to all of them
        if len(self.leader_node.peers) > 0:
            for node_uri in self.leader_node.peers:
                node = Pyro5.api.Proxy(node_uri)
                if node.object_id != self.leader_node.object_id:
                    status = node.receive_leader_heartbeat(self.leader_node.uri)
                    if not status:
                        print(f"Node {node.object_id} is not available.")
        else:
            print("No followers to send heartbeat.")
        self.node_heartbeat_timer = threading.Timer(
            self.__HEARTBEAT_INTERVAL,
            self.send_followers_heartbeat
        )
        self.node_heartbeat_timer.daemon = True
        self.node_heartbeat_timer.start()

    def start_leader_heartbeats(self):
        """Start the leader heartbeats."""
        self.node_heartbeat_timer = threading.Timer(
            self.__HEARTBEAT_INTERVAL,
            self.send_followers_heartbeat
        )
        self.node_heartbeat_timer.daemon = True
        self.node_heartbeat_timer.start()

"""Raft heartbeat module. Manages the heartbeat process.
"""
import threading
import time
import Pyro5.api
from log_operator import write_log

class RaftHeartbeat:
    """Raft heartbeat class. Manages the heartbeat process.

    Methods:
        send_heartbeat: Send heartbeat to the leader node.
        send_followers_heartbeat: Send heartbeat to all followers.
        start_leader_heartbeats: Start the leader heartbeats.
    """

    def __init__(self):
        # heartbeat interval in milliseconds
        self.heartbeat_interval = 1.0
        self.leader_node = None
        self.node_heartbeat_timer = None
        self.time_remaning_for_heartbeat = self.heartbeat_interval
        self.thread_heartbeat_timer = threading.Thread(target=self.start_leader_heartbeats)

    def send_follower_to_leader_heartbeat(self, follower_uri: str):
        """Send heartbeat to the leader node."""
        if self.leader_node:
            self.leader_node.receive_follower_heartbeat(follower_uri)
        else:
            with open(f"{self.leader_node.object_id}_log.txt", 'a', encoding='UTF-8') as f:
                f.write("No followers to send heartbeat.\n")

    def send_followers_heartbeat(self):
        """Send heartbeat to all followers."""
        write_log(
            object_id = self.leader_node.object_id,
            message = "Sending Heartbeats to all followers."
        )

        # send heartbeats to all the peer nodes
        if len(self.leader_node.peers) > 0:
            for node_uri in self.leader_node.peers:
                node = Pyro5.api.Proxy(node_uri)
                if node.object_id != self.leader_node.object_id:
                    status = node.receive_leader_heartbeat(self.leader_node.uri)
                    if not status:
                        write_log(
                            object_id = self.leader_node.object_id,
                            message = f"Followers {node.object_id} didnt receive heartbeat."
                        )
                    write_log(
                        object_id = self.leader_node.object_id,
                        message = f"Follower {node.object_id} received heartbeat."
                    )
        else:
            write_log(
                object_id = self.leader_node.object_id,
                message = "No followers to send Heartbeats."
            )

    def start_leader_heartbeats(self):
        """Start the leader heartbeats."""
        while True:
            time.sleep(self.heartbeat_interval)

            self.time_remaning_for_heartbeat -= 1

            if self.time_remaning_for_heartbeat <= 0:
                self.send_followers_heartbeat()
                self.time_remaning_for_heartbeat = self.heartbeat_interval

            if self.leader_node.state != "leader":
                break

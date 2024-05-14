"""Raft heartbeat module. Manages the heartbeat process.
"""
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
        self.node_heartbeat_timer = None
        self.time_remaning_for_heartbeat = self.heartbeat_interval

    def send_follower_to_leader_heartbeat(self, follower_uri: str, leader_node):
        """Send heartbeat to the leader node."""
        if leader_node:
            leader_node.receive_follower_heartbeat(follower_uri)
        else:
            with open(f"{leader_node.object_id}_log.txt", 'a', encoding='UTF-8') as f:
                f.write("No followers to send heartbeat.\n")

    def send_followers_heartbeat(self, leader_node):
        """Send heartbeat to all followers.
        
        Args:
            leader_node (RaftNode): Leader node instance.
        """
        nameserver_pyro = Pyro5.api.locate_ns()
        write_log(
            object_id = leader_node.object_id,
            message = "Sending Heartbeats to all followers."
        )
        dict_raft_nodes = dict(nameserver_pyro.list(prefix="raft_node_"))
        dict_raft_nodes.pop(leader_node.object_id)
        # send heartbeats to all the peer nodes
        if len(dict_raft_nodes) > 0:
            write_log(
                leader_node.object_id,
                f"Nodes to send Heartbeats: {dict_raft_nodes}"
            )
            for node_id, node_uri in dict_raft_nodes.items():
                write_log(
                    object_id = leader_node.object_id,
                    message = f"Sending Heartbeat to {node_uri}."
                )
                if node_id != leader_node.object_id:
                    node = Pyro5.api.Proxy(node_uri)
                    status = node.receive_leader_heartbeat(leader_node.uri)
                    if not status:
                        write_log(
                            object_id = leader_node.object_id,
                            message = f"Follower {node.object_id} didn't receive heartbeat."
                        )
                        continue
                    write_log(
                        object_id = leader_node.object_id,
                        message = f"Follower {node.object_id} received heartbeat."
                    )
                else:
                    write_log(
                        object_id = leader_node.object_id,
                        message = "Leader node doesn't receive heartbeat."
                    )
            write_log(
                object_id = leader_node.object_id,
                message = "Heartbeats sent to all followers."
            )
        else:
            write_log(
                object_id = leader_node.object_id,
                message = "No followers to send Heartbeats."
            )

    def start_leader_heartbeats(self, leader_node):
        """Start the leader heartbeats."""
        while True:
            time.sleep(self.heartbeat_interval)

            self.time_remaning_for_heartbeat -= 1

            if self.time_remaning_for_heartbeat <= 0:
                self.send_followers_heartbeat(leader_node)
                self.time_remaning_for_heartbeat = self.heartbeat_interval

            if (leader_node.state != "leader"
                or not leader_node.active
            ):
                break

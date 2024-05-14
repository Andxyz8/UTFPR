"""Raft election module.
"""
import random
import time
import threading
import Pyro5.api
from raft_heartbeat import RaftHeartbeat
from log_operator import write_log

class RaftElection:
    """Raft election class. Manages the election process.

    Methods:
        start_election_timer: Start the election timer.
        start_election: Start the election process.
        reset_election_timer: Reset the election timer.
        request_votes: Request votes for all the nodes.

    Args:
        raft_node (RaftNode): Raft node instance.
    """

    def __init__(self, raft_node):
        self.raft_node = raft_node
        self.election_timer = None
        self.raft_heartbeats = RaftHeartbeat()
        self.time_remaning_for_election = self.election_timeout
        self.thread_election_timer = threading.Thread(target=self.start_election_timer)

    @property
    def election_timeout(self):
        """Returns a random election timeout value between 1 and 30 seconds.
        """
        return int(random.randint(3000, 5000) / 1000.0)

    def start_election_timer(self):
        """Start the election process.
        """
        while True:
            time.sleep(1.0)
            if self.raft_node.state == "leader":
                self.raft_heartbeats.start_leader_heartbeats(self.raft_node)
                continue

            self.time_remaning_for_election -= 1
            # Starts the election proccess
            if self.time_remaning_for_election <= 0:
                self.raft_node.start_election()

    def reset_election_timer(self):
        """Reset the election timer.
        """
        if self.election_timer:
            self.time_remaning_for_election = self.election_timeout
            write_log(
                object_id = self.raft_node.object_id,
                message = f"Resetting election timer. New timeout {self.time_remaning_for_election} seconds."
            )

    def request_votes(self):
        """Request votes for all the nodes.

        Returns:
            int: number of votes received.
        """
        # Starts at 1 because the candidate votes for itself
        votes = 1
        nameserver_pyro = Pyro5.api.locate_ns()
        dict_raft_nodes = nameserver_pyro.list(prefix="raft_node_")
        dict_raft_nodes.pop(self.raft_node.object_id)
        if len(dict_raft_nodes) > 0:
            for node_id, node_uri in dict_raft_nodes.items():
                write_log(
                    object_id = self.raft_node.object_id,
                    message = f"{self.raft_node.object_id} requesting vote from {node_id}."
                )
                if node_uri != self.raft_node.object_id:
                    node = Pyro5.api.Proxy(node_uri)
                    vote_status = node.request_vote(self.raft_node.object_id)
                    if vote_status:
                        votes += 1
                        write_log(
                            object_id = self.raft_node.object_id,
                            message = f"Vote received from {node.object_id}."
                        )
                    else:
                        write_log(
                            object_id = self.raft_node.object_id,
                            message = f"No vote received from {node.object_id}."
                        )
        return votes

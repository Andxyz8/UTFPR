"""Raft election module.
"""
import random
import time
import threading
import Pyro5.api
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
        self.time_remaning_for_election = self.election_timeout
        self.thread_election_timer = threading.Thread(target=self.start_election_timer)

    @property
    def election_timeout(self):
        """Returns a random election timeout value between 1 and 30 seconds.
        """
        return random.randint(2000, 30000) / 1000.0

    def start_election_timer(self):
        """Start the election process.
        """
        while self.time_remaning_for_election:
            if self.raft_node.state == "leader":
                break

            time.sleep(1.0)
            self.time_remaning_for_election -= 1
            # Starts the election proccess
            if self.time_remaning_for_election <= 0:
                write_log(
                    object_id = self.raft_node.object_id,
                    message = "Starting election..."
                )
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

    def request_votes(self, candidate_uri: str, all_nodes: list):
        """Request votes for all the nodes.

        Args:
            candidate_uri (str): candidate uri.

        Returns:
            int: number of votes received.
        """
        # Starts at 1 because the candidate votes for itself
        votes = 1
        if len(all_nodes) > 1:
            for node_uri in all_nodes:
                node = Pyro5.api.Proxy(node_uri)
                print(f"object_id: {node.object_id} Peers: {node.peers}")
                if node.uri != candidate_uri:
                    vote_status = node.request_vote(candidate_uri)
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

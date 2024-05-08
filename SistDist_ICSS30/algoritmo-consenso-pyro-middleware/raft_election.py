"""Raft election module.
"""
import random
import threading
import Pyro5.api

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

    def start_election_timer(self):
        """Start the election timer.
        """
        # random interval for election 5000ms e 12000ms
        self.__election_timeout = random.randint(1000, 3000) / 1000.0
        self.election_timer = threading.Timer(self.__election_timeout, self.start_election)
        self.election_timer.daemon = True
        self.election_timer.start()

    def start_election(self):
        """Start the election process.
        """
        # Inicia o processo da eleição
        print(f"Node {self.raft_node.object_id} starting election...")
        self.raft_node.start_election()

    def reset_election_timer(self):
        """Reset the election timer.
        """
        if self.election_timer:
            self.election_timer.cancel()
        self.start_election_timer()

    def request_votes(self, candidate_uri: str, all_nodes: list):
        """Request votes for all the nodes.

        Args:
            candidate_uri (str): candidate uri.

        Returns:
            int: number of votes received.
        """
        print(all_nodes)
        # Starts at 1 because the candidate votes for itself
        votes = 1
        if len(all_nodes) > 1:
            for node_uri in all_nodes:
                node = Pyro5.api.Proxy(node_uri)
                if node.uri != candidate_uri:
                    vote_status = node.request_vote(candidate_uri)
                    if vote_status:
                        votes += 1
        return votes

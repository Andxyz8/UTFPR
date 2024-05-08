import random
import threading

class RaftElection:
    def __init__(self, raft_node):
        self.raft_node = raft_node
        # Tempo aleatório entre 5000ms e 12000ms
        self.election_timeout = random.randint(5000, 12000) / 1000.0
        self.election_timer = None

    def start_election_timer(self):
        self.election_timer = threading.Timer(self.election_timeout, self.start_election)
        self.election_timer.daemon = True
        self.election_timer.start()

    def start_election(self):
        # Iniciar eleição
        print(f"Node {self.raft_node.object_id} starting election...")
        self.raft_node.start_election()

    def reset_election_timer(self):
        if self.election_timer:
            self.election_timer.cancel()
        self.start_election_timer()
    
    def request_vote(self, all_nodes: list):
        """Request vote to all nodes."""
        for node in all_nodes:
            if node.object_id != self.raft_node.object_id:
                node.request_vote(self.raft_node.object_id)
        self.reset_election_timer()

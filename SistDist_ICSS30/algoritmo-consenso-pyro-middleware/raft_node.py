"""RaftNode class that represents a node in the Raft algorithm.
"""
from uuid import uuid4
import Pyro5.api
import Pyro5.core
import Pyro5.client
from raft_election import RaftElection
from raft_heartbeat import RaftHeartbeat

@Pyro5.api.expose
class RaftNode(object):
    """RaftNode class that represents a node in the Raft algorithm.

    Attributes:
        all_nodes (list): list of all nodes.
        heartbeats (RaftHeartbeat): RaftHeartbeat object.

    Methods:
        request_vote: Request vote for a candidate.
        initialize_node: Initialize the node with the URI and start the election timer.
        start_election: Start the election process for a candidate, if possible.
        receive_leader_heartbeat: Receive heartbeat from the leader node.
        receive_follower_heartbeat: Receive heartbeat from a follower node.
        leader_add_follower_peer: Add follower to the leader peer list.
        __follower_add_follower_peer: Add follower to the follower peer list.
        add_peer: Add peer to the peers list.
        append_entries: Append log to the follower log list.
        replicate_to_followers: Replicate log to all followers.
        commit_entry: Commit the entry to the log.
        commit_to_followers: Commit the entry to all followers.
        rollback_entry: Rollback the last entry of the log.
        rollback_followers: Rollback the last entry of the log in all followers.
        receive_command: Receive command from the client.

    Args:
        object_id (str): object id.
    """

    all_nodes: list = []
    heartbeats: RaftHeartbeat = None

    def __init__(self, object_id: str = uuid4()):
        self.__dict_raft_node = {
            'object_id': object_id,
            'state': 'follower',
            'leader_uri': None,
            'uri': None
        }
        self.current_value = None
        self.commited: bool = False
        self.active: bool = False
        self.__log: list = []
        self.__obj_election: RaftElection = RaftElection(self)
        self.__peers: list[str] = []

    def __str__(self) -> str:
        return f"""
            RaftNode: {self.object_id}
            uri: {self.uri}
            leader_uri: {self.leader_uri}
            state: {self.state}
            value: {self.current_value}
            commited: {self.commited}
            peers: {self.peers}
            log: {self.log}\n
        """

    def __repr__(self) -> str:
        return self.__str__()

    @property
    def uri(self):
        """Returns:
            str: node uri.
        """
        return self.__dict_raft_node['uri']

    @uri.setter
    def uri(self, uri):
        if uri is not None:
            self.__dict_raft_node['uri'] = uri

    @property
    def object_id(self):
        """Returns:
            str: object id.
        """
        return self.__dict_raft_node['object_id']

    @object_id.setter
    def object_id(self, object_id):
        self.__dict_raft_node['object_id'] = object_id

    @property
    def leader_uri(self):
        """Returns:
            str: leader URI.
        """
        return self.__dict_raft_node['leader_uri']

    @leader_uri.setter
    def leader_uri(self, leader_uri):
        self.__dict_raft_node['leader_uri'] = leader_uri

    @property
    def state(self):
        """Returns:
            str: node state.
        """
        return self.__dict_raft_node['state']

    @state.setter
    def state(self, state):
        self.__dict_raft_node['state'] = state

    @property
    def current_value(self):
        """Returns:
            list: value list of this node.
        """
        return self.__current_value

    @current_value.setter
    def current_value(self, current_value):
        self.__current_value = current_value

    @property
    def commited(self):
        """Returns:
            bool: committed value of this node.
        """
        return self.__committed

    @commited.setter
    def commited(self, committed):
        self.__committed = committed

    @property
    def active(self):
        """Returns:
            bool: active status of this node.
        """
        return self.__active

    @active.setter
    def active(self, status):
        self.__active = status

    @property
    def peers(self):
        """Returns:
            list[str]: peers list of this node.
        """
        return self.__peers

    @peers.setter
    def peers(self, peers):
        self.__peers = peers

    @property
    def obj_election(self):
        """Returns:
            RaftElection: RaftElection object.
        """
        return self.__obj_election

    @obj_election.setter
    def obj_election(self, obj_election):
        self.__obj_election = obj_election

    @property
    def log(self):
        """Returns:
            list: logs list of this node.
        """
        return self.__log

    @log.setter
    def log(self, log):
        self.__log = log

    def request_vote(self, candidate_id: str):
        """Request vote for a candidate.

        Args:
            candidate_id (str): candidate id.

        Returns:
            bool: True if the vote was granted, False otherwise.
        """
        if candidate_id not in self.peers:
            self.add_peer(candidate_id)

        if self.state == 'leader' and self.active is True:
            return False

        if self.state == 'follower' or self.leader_uri is None:
            print(f"Node {self.object_id} voted for {candidate_id}.")
            return True

        if self.state == 'candidate':
            print(f"Node {self.object_id} is also a candidate.")
            return False
        return False

    def initialize_node(self, uri: str):
        """Initialize the node with the URI and start the election timer.

        Args:
            uri (str): URI of the node.
        """
        self.uri = uri
        # self.obj_election.start_election_timer()

    def start_node(self):
        """Start the node.
        """
        print(f"Node {self.object_id} started.")
        print(self.all_nodes)
        self.active = True
        self.all_nodes.append(self.uri)
        self.obj_election.start_election_timer()
        print(self.all_nodes)

    def start_election(self):
        """Start the election process for a candidate, if possible.
        """
        if self.state == 'leader':
            print(f"Node {self.object_id} I'm the leader, I can't start an election")
            return

        if self.state == 'follower' and self.leader_uri is None:
            self.state = 'candidate'

        if self.state == 'candidate':
            num_votes = self.obj_election.request_votes(self.uri, self.all_nodes)
            if num_votes > (len(self.all_nodes) // 2):
                self.state = 'leader'
                self.leader_uri = self.uri
                self.active = True
                self.heartbeats = RaftHeartbeat()
                self.heartbeats.leader_node = self
                self.heartbeats.start_leader_heartbeats()
                print("A new leader was elected: ", self.object_id)

    def receive_leader_heartbeat(self, leader_uri: str):
        """Receive heartbeat from the leader node.
        """
        if self.state == 'leader':
            return
        if self.leader_uri is None:
            self.leader_uri = leader_uri

        self.obj_election.reset_election_timer()
        self.heartbeats.send_follower_to_leader_heartbeat(self.uri)

        return True

    def receive_follower_heartbeat(self, follower_uri: str):
        """Receive heartbeat from a follower node.

        Args:
            follower_uri (str): follower URI.
        """
        if self.state == 'leader':
            return True

        if follower_uri not in self.peers:
            self.add_peer(follower_uri)

        follower_node = Pyro5.api.Proxy(follower_uri)
        if follower_node.state == 'follower':
            return True

    def leader_add_follower_peer(self, leader_uri: str):
        """ Add follower to the leader peer list.

        Args:
            leader_uri (str): leader URI.
        """
        raft_node_leader: RaftNode = Pyro5.api.Proxy(leader_uri)
        raft_node_leader.add_peer(self.uri)
        self.__follower_add_follower_peer(raft_node_leader.peers)

    def __follower_add_follower_peer(self, peers: list[str]):
        """Add follower to the follower peer list.

        Args:
            peers (list[str]): list of peers.
        """
        for peer_uri in peers:
            if peer_uri != self.uri:
                peer: RaftNode = Pyro5.api.Proxy(peer_uri)
                self.add_peer(peer_uri)
                peer.add_peer(self.uri)

    def add_peer(self, peer_uri: str):
        """Add peer to the peers list.

        Args:
            peer_uri (str): peer URI.
        """
        if peer_uri not in self.__peers:
            self.__peers.append(peer_uri)

    def append_entries(self, log_register):
        """Append log to the follower log list.

        Args:
            log_register (dict): dict with log information.

        Returns:
            bool: True if the log was appended to the log list,
                False otherwise.
        """
        # Receber log do líder
        if self.state == 'follower':
            # Anexar log ao log local
            self.commited = False
            self.__log.append(log_register)
            return True
        print("I'm not a follower, I can't receive logs")
        return False

    def replicate_to_followers(self, new_log):
        """Replicate log to all followers.

        Args:
            new_log (dict): dict with log information.

        Returns:
            bool: True if the log was replicated to the
                majority of the followers, False otherwise.
        """
        if len(self.__peers) == 0:
            return True

        replicated = 0
        for peer_uri in self.__peers:
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)

            if peer.append_entries(new_log):
                replicated += 1

        if replicated >= (len(self.__peers) // 2):
            return True
        return False

    def commit_entry(self, log_register):
        """Commit the entry to the log.
        """
        self.log[-1]['commited'] = True
        self.current_value = log_register['value']
        self.commited = True

    def commit_to_followers(self):
        """Commit the entry to all followers.
        """
        for peer_uri in self.__peers:
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            peer.commit_entry(self.log[-1])

    def rollback_entry(self):
        """Rollback the last entry of the log.
        """
        self.log.pop()
        self.commited = True

    def rollback_followers(self):
        """Rollback the last entry of the log in all followers.
        """
        for peer_uri in self.__peers:
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            peer.rollback_entry()

    def receive_command(self, command: str):
        """Receive command from the client.

        Args:
            command (str): command to be executed.
        """
        new_value = command.split(' ')[1]
        print(f"Command Received: {command}")
        print("LEADER BEFORE COMMAND\n", self)
        # Receber comando do cliente
        if self.state == 'leader':
            if command.startswith('SET'):
                log_register = {
                    'command': command,
                    'value': new_value,
                    'commited': False
                }
                self.log.append(
                    log_register
                )
                self.commited = False
                status = self.replicate_to_followers(log_register)
                if status:
                    self.current_value = new_value
                    self.log[-1]['commited'] = True
                    self.commit_to_followers()
                    self.commited = True
                else:
                    # rollback to the last value used
                    self.current_value = self.log[-2]['value']
                    self.rollback_followers()
                    self.commited = True
        else:
            print("I'm not the leader, I can't receive commands")

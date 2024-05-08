from uuid import uuid4
import Pyro5.api
import Pyro5.core
import Pyro5.client
from raft_election import RaftElection
from raft_heartbeat import RaftHeartbeat

@Pyro5.api.expose
class RaftNode(object):

    all_nodes: list = []
    # heartbeats: RaftHeartbeat = RaftHeartbeat()

    def __init__(self, object_id: str = uuid4(), leader_uri: str = None):
        self.__dict_raft_node = {
            'object_id': object_id,
            'leader_uri': leader_uri,
            'state': 'follower' if leader_uri is not None else 'leader',
            'uri': None
        }
        self.current_value = None
        self.commited: bool = False
        self.__log: list = []
        # self.__obj_election: RaftElection = RaftElection(self)
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

    def initialize_node(self, uri: str):
        self.uri = uri
        self.all_nodes.append(self.uri)
        # self.obj_election.start_election_timer()

        if self.state == 'follower':
            self.leader_add_follower_peer(self.leader_uri)
            self.add_peer(self.leader_uri)
        else:
            self.leader_uri = uri

    def start_election(self):
        if self.state == 'follower' and self.leader_uri is None:
            self.state = 'candidate'

        if self.state == 'candidate':
            votes = self.obj_election.request_votes(self.all_nodes)
            if votes >= len(self.all_nodes) / 2:
                self.state = 'leader'
                self.leader_uri = self.uri
                self.obj_election.reset_election_timer()
                self.heartbeats.leader_node = self
                self.heartbeats.send_heartbeat()

    def request_vote(self, candidate_id: str):
        if self.state == 'follower':
            self.state = 'candidate'
            return True
        return False

    def leader_add_follower_peer(self, leader_uri: str):
        raft_node_leader: RaftNode = Pyro5.api.Proxy(leader_uri)
        raft_node_leader.add_peer(self.uri)
        self.__follower_add_follower_peer(raft_node_leader.peers)

    def __follower_add_follower_peer(self, peers: list[str]):
        for peer_uri in peers:
            if peer_uri != self.uri:
                peer: RaftNode = Pyro5.api.Proxy(peer_uri)
                self.add_peer(peer_uri)
                peer.add_peer(self.uri)

    def add_peer(self, peer_uri: str):
        if peer_uri not in self.__peers:
            self.__peers.append(peer_uri)

    def append_entries(self, log_register):
        # Receber log do líder
        if self.state == 'follower':
            # Anexar log ao log local
            self.commited = False
            self.__log.append(log_register)
            print(self)
            return True
        print("I'm not a follower, I can't receive logs")
        return False

    def replicate_to_followers(self, new_log):
        if len(self.__peers) == 0:
            return True

        replicated = 0
        for peer_uri in self.__peers:
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            
            print("FOLLOWER ", peer.object_id," BEFORE REPLICATION\n", peer)
            if peer.append_entries(new_log):
                replicated += 1
            print("FOLLOWER ", peer.object_id," AFTER REPLICATION\n", peer)

        if replicated >= (len(self.__peers) // 2):
            return True
        return False

    def commit_entry(self, log_register):
        self.log[-1]['commited'] = True
        self.current_value = log_register['value']
        self.commited = True

    def commit_to_followers(self):
        for peer_uri in self.__peers:
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            print("FOLLOWER ", peer.object_id," BEFORE COMMITING\n", peer)
            peer.commit_entry(self.log[-1])
            print("FOLLOWER ", peer.object_id," AFTER COMMITING\n", peer)

    def rollback_entry(self):
        self.log.pop()
        self.commited = True

    def rollback_followers(self):
        for peer_uri in self.__peers:
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            print("FOLLOWER ", peer.object_id," BEFORE ROLLBACKING\n", peer)
            peer.rollback_entry()
            print("FOLLOWER ", peer.object_id," AFTER ROLLBACKING\n", peer)

    def receive_command(self, command: str):
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
                print("LEADER BEFORE REPLICATE FOLLOWERS\n", self)
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
                print("LEADER AFTER COMMIT/ROLLBACK FOLLOWERS\n", self)
        else:
            print("I'm not the leader, I can't receive commands")

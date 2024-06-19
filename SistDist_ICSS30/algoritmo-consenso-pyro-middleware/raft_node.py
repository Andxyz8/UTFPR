"""RaftNode class that represents a node in the Raft algorithm.
"""
from uuid import uuid4
import Pyro5.api
import Pyro5.core
import Pyro5.client
from raft_election import RaftElection
from log_operator import write_log

@Pyro5.api.expose
class RaftNode(object):
    """RaftNode class that represents a node in the Raft algorithm.

    Methods:
        request_vote: Request vote for a candidate.
        initialize_node: Initialize the node with the URI and start the election timer.
        start_election: Start the election process for a candidate, if possible.
        receive_leader_heartbeat: Receive heartbeat from the leader node.
        receive_follower_heartbeat: Receive heartbeat from a follower node.
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

    def __str__(self) -> str:
        return f"""
            RaftNode: {self.object_id}
            active: {self.active}
            uri: {self.uri}
            leader_uri: {self.leader_uri}
            state: {self.state}
            value: {self.current_value}
            commited: {self.commited}
            log: {self.log}\n
        """

    def __repr__(self) -> str:
        return self.__str__()

    def to_string(self) -> str:
        """Returns:
            str: node information.
        """
        return self.__str__().strip().replace(':', ': ')

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
        if self.state == state:
            return
        write_log(
            object_id = self.object_id,
            message = f"{self.object_id} changed state from {self.state} to {state}"
        )
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

    def start_node(self):
        """Start the node.
        """
        write_log(
            object_id = self.object_id,
            message = f"{self.object_id} started with election interval of {self.obj_election.election_timeout} seconds."
        )
        self.active = True
        self.state = 'follower'
        self.obj_election.thread_election_timer.start()

    def turn_off_node(self):
        """Turn off the node.
        """
        self.active = False
        self.state = 'follower'
        self.leader_uri = None

    def initialize_node(self, uri: str):
        """Initialize the node with the URI and start the election timer.

        Args:
            uri (str): URI of the node.
        """
        self.uri = uri

    def request_vote(self, candidate_uri: str):
        """Send it's vote for a candidate.

        Args:
            candidate_uri (str): candidate URI.

        Returns:
            bool: True if the vote was granted, False otherwise.
        """
        if self.active is False:
            return False

        if self.state == 'leader' and self.active is True:
            # restart the election timer for the candidate
            node_candidate = Pyro5.api.Proxy(candidate_uri)
            node_candidate.obj_election.reset_election_timer()
            return False

        if self.state == 'follower' or self.leader_uri is None:
            write_log(
                object_id = self.object_id,
                message = f"{self.object_id} voted for {candidate_uri}"
            )
            return True

        if self.state == 'candidate':
            write_log(
                object_id = self.object_id,
                message = f"Can't vote on {candidate_uri}, node {self.object_id} is also a candidate."
            )
            self.state = 'follower'
            return False
        return False

    def start_election(self):
        """Start the election process for a candidate, if possible.
        """
        if self.active is False:
            return

        dict_raft_nodes = dict(Pyro5.api.locate_ns().list(prefix="raft_node_"))

        if self.state == 'leader':
            write_log(
                object_id = self.object_id,
                message = f"{self.object_id} I'm the leader, I can't start an election."
            )
            return

        # check if the leader is active
        if self.leader_uri is not None:
            leader_node = Pyro5.api.Proxy(self.leader_uri)
            if leader_node.active:
                if self.state != 'follower':
                    self.state = 'follower'
                return
            self.leader_uri = None

        if self.state == 'follower':
            self.state = 'candidate'
            return

        if self.state == 'candidate':
            write_log(
                object_id = self.object_id,
                message = f"{self.object_id} starting election..."
            )
            num_votes = self.obj_election.request_votes()
            active_nodes = [
                node_uri for node_uri in dict_raft_nodes.values()
                if Pyro5.api.Proxy(node_uri).active and node_uri != self.uri
            ]

            if num_votes >= (len(active_nodes)+1)//2:
                self.leader_uri = self.uri
                self.active = True
                self.state = 'leader'
                write_log(
                    object_id = self.object_id,
                    message = f"{self.object_id} elected as leader."
                )
            else:
                self.obj_election.reset_election_timer()
                self.state = 'follower'
                for node_uri in dict_raft_nodes.values():
                    node = Pyro5.api.Proxy(node_uri)
                    if node.state == 'leader':
                        uri = node.uri
                        break

                self.leader_uri = uri
                write_log(
                    object_id = self.object_id,
                    message = f"{self.object_id} couldn't be elected as leader."
                )
        return

    def receive_leader_heartbeat(self, leader_uri: str):
        """Receive heartbeat from the leader node.
        """
        if self.state == 'leader':
            return False

        if self.leader_uri != leader_uri:
            self.leader_uri = leader_uri

        if self.state == 'candidate':
            leader_node = Pyro5.api.Proxy(leader_uri)
            if leader_node.active:
                self.state = 'follower'

        if self.state == 'follower' and self.active is True:
            self.obj_election.reset_election_timer()

            if self.current_value is None:
                self.current_value = Pyro5.api.Proxy(leader_uri).current_value

            if self.leader_uri is None:
                self.leader_uri = leader_uri

            write_log(
                object_id = self.object_id,
                message = f"{self.object_id} in state {self.state} received heartbeat from leader {leader_uri}"
            )

        return self.send_heartbeat_confirmation_to_leader(leader_uri)

    def send_heartbeat_confirmation_to_leader(self, leader_uri: str):
        """Send back a confirmation of the heartbeat to the leader node.

        Args:
            leader_uri (str): leader URI.
        """
        leader_node = Pyro5.api.Proxy(leader_uri)
        if leader_node.active:
            return leader_node.receive_follower_heartbeat(self.uri)
        write_log(
            object_id = self.object_id,
            message = f"{self.object_id} No Leader to send heartbeat."
        )
        return False

    def receive_follower_heartbeat(self, follower_uri: str):
        """Receive heartbeat from a follower node.

        Args:
            follower_uri (str): follower URI.
        """
        if self.state == 'leader':
            return True

        follower_node = Pyro5.api.Proxy(follower_uri)
        if follower_node.state == 'follower':
            return True
        return False

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
        write_log(
            object_id = self.object_id,
            message = f"{self.object_id} is not a follower, can't append entries."
        )
        return False

    def replicate_to_followers(self, new_log):
        """Replicate log to all followers.

        Args:
            new_log (dict): dict with log information.

        Returns:
            bool: True if the log was replicated to the
                majority of the followers, False otherwise.
        """
        pyro_nameserver = Pyro5.api.locate_ns()
        peers = pyro_nameserver.list(prefix="raft_node_")

        if len(peers) == 1:
            return True

        peers.pop(self.object_id)

        replicated = 1
        for peer_uri in peers.values():
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            if peer.state == 'follower' and peer.append_entries(new_log):
                replicated += 1

        if replicated >= (len(peers) + 1)// 2:
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
        nameserver = Pyro5.api.locate_ns()
        peers = nameserver.list(prefix="raft_node_")

        peers.pop(self.object_id)

        for peer_uri in peers.values():
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            peer.commit_entry(self.log[-1])
            print(peer.to_string())

    def rollback_entry(self):
        """Rollback the last entry of the log.
        """
        self.log.pop()
        self.commited = True

    def rollback_followers(self):
        """Rollback the last entry of the log in all followers.
        """
        nameserver = Pyro5.api.locate_ns()
        peers = nameserver.list(prefix="raft_node_")
        peers.pop(self.object_id)

        for peer_uri in peers:
            peer: RaftNode = Pyro5.api.Proxy(peer_uri)
            if peer.state == 'follower':
                peer.rollback_entry()
            print(peer.to_string())

    def receive_command(self, command: str):
        """Receive command from the client.

        Args:
            command (str): command to be executed.
        """
        new_value = command.split(' ')[1]
        print(f"Command Received: {command}")
        print("LEADER BEFORE COMMAND\n", self)
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
                else:
                    # Rollback to the last value used
                    self.current_value = self.log[-2]['value']
                    self.rollback_followers()
                self.commited = True
                write_log(
                    object_id = self.object_id,
                    message = f"{self.object_id} SET command executed."
                )
            if command.startswith('ADD'):
                log_register = {
                    'command': command,
                    'value': int(self.current_value) + int(new_value),
                    'commited': False
                }
                self.log.append(
                    log_register
                )
                self.commited = False
                status = self.replicate_to_followers(log_register)
                if status:
                    self.current_value = int(self.current_value) + int(new_value)
                    self.log[-1]['commited'] = True
                    self.commit_to_followers()
                else:
                    # Rollback to the last value used
                    self.current_value = self.log[-2]['value']
                    self.rollback_followers()
                self.commited = True
                write_log(
                    object_id = self.object_id,
                    message = f"{self.object_id} ADD command executed."
                )
            if command.startswith('TURN ON'):
                self.start_node()
                write_log(
                    object_id = self.object_id,
                    message = f"{self.object_id} command executed."
                )
            if command.startswith('TURN OFF'):
                self.turn_off_node()
                write_log(
                    object_id = self.object_id,
                    message = f"{self.object_id} command executed."
                )
            return True
        print("I'm not the leader, I can't receive commands")
        return False

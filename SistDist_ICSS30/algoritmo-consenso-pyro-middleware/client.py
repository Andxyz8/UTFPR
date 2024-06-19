import sys
import Pyro5.api
from raft_node import RaftNode
from log_operator import write_log


class Client:
    def __init__(self, client_id: str):
        self.client_id = f"client_{client_id}"
        self.leader_node: RaftNode = None
        write_log(
            object_id = self.client_id,
            message = f"[X] Client {self.client_id} started."
        )

    def __get_leader_node(self):
        # Get the nameserver object
        nameserver_pyro = Pyro5.api.locate_ns()
        # Get all the raft nodes: dict with the object_id as key and the uri as value
        dict_raft_nodes = dict(nameserver_pyro.list(prefix="raft_node_"))

        for node_uri in dict_raft_nodes.values():
            node = Pyro5.api.Proxy(node_uri)
            if node.state == "leader" and node.active:
                self.leader_node = node
                return

    def __check_leader_available(self):
        self.__get_leader_node()

        # Check if the leader node is available and active
        if (self.leader_node is None
            or self.leader_node.active is False
        ):
            write_log(
                object_id = self.client_id,
                message = "[X] No leader found. Wait for the election process to finish and send a new command."
            )
            return False
        return True

    def __check_valid_value(self, value: str):
        """Check if the value is a valid integer.

        Args:
            value (str): Value to be checked.

        Returns:
            bool: True if the value is a valid number, False otherwise.
        """
        try:
            float(value)
            return True
        except ValueError:
            write_log(
                object_id = self.client_id,
                message = f"[X] Invalid value: {value}. Please enter a valid integer."
            )
        return False

    def set_value_command(self, command: str):
        """Perform a SET command.

        Args:
            command (str): Command with the value to be set.
        """
        if not self.__check_leader_available():
            return

        value = command.split(" ")[1]
        if not self.__check_valid_value(value):
            return

        write_log(
            object_id = self.client_id,
            message = f"[X] Command '{command}' sent to leader node."
        )

        command_status = self.leader_node.receive_command(f"SET {value}")
        if command_status:
            write_log(
                object_id = self.client_id,
                message = f"[X] Command '{command}' executed."
            )
            return
        write_log(
            object_id = self.client_id,
            message = f"[X] Something is wrong. Command '{command}' failed."
        )

    def add_value_command(self, command: str):
        """Perform an ADD command.

        Args:
            command (str): Command with the value to be added.
        """
        if not self.__check_leader_available():
            return

        value = command.split(" ")[1]
        if not self.__check_valid_value(value):
            return

        write_log(
            object_id = self.client_id,
            message = f"[X] Command '{command}' sent to leader node."
        )

        command_status = self.leader_node.receive_command(f"ADD {value}")
        if command_status:
            write_log(
                object_id = self.client_id,
                message = f"[X] Command '{command}' executed."
            )
            return
        write_log(
            object_id = self.client_id,
            message = f"[X] Something is wrong. Command '{command}' failed."
        )

    def turn_on_command(self, command: str):
        """Turn on any node on the nameserver.

        Args:
            command (str): Command to turn off a node.
        """
        if not self.__check_leader_available():
            return

        write_log(
            object_id = self.client_id,
            message = f"[X] Command '{command}' sent to leader node."
        )

        command_status = self.leader_node.receive_command(command)
        if command_status:
            write_log(
                object_id = self.client_id,
                message = f"[X] Command '{command}' executed."
            )
            return
        write_log(
            object_id = self.client_id,
            message = f"[X] Something is wrong. Command '{command}' failed."
        )

    def turn_off_command(self, command: str):
        """Turn off any node on the nameserver.

        Args:
            command (str): Command to turn off a node.
        """

        if not self.__check_leader_available():
            return

        write_log(
            object_id = self.client_id,
            message = f"[X] Command '{command}' sent to leader node."
        )

        command_status = self.leader_node.receive_command(command)
        if command_status:
            write_log(
                object_id = self.client_id,
                message = f"[X] Command '{command}' executed."
            )
            return
        write_log(
            object_id = self.client_id,
            message = f"[X] Something is wrong. Command '{command}' failed."
        )

    def list_nodes(self) -> None:
        """List nodes to the output.
        """
        nameserver_pyro = Pyro5.api.locate_ns()
        dict_raft_nodes = dict(nameserver_pyro.list(prefix="raft_node_"))

        for node_uri in dict_raft_nodes.values():
            node = Pyro5.api.Proxy(node_uri)
            print(node.to_string())

# Get the client id from the command line arguments
CLIENT_ID = sys.argv[1]

client = Client(CLIENT_ID)

# Try except for keyboards interrupts
try:
    # Loop to get the commands from the user
    while True:
        COMMAND = str(input("Type your command: "))

        if COMMAND.startswith("SET"):
            client.set_value_command(COMMAND)

        if COMMAND.startswith("ADD"):
            client.add_value_command(COMMAND)

        if COMMAND.startswith("TURN ON"):
            client.turn_on_command(COMMAND)

        if COMMAND.startswith("TURN OFF"):
            client.turn_off_command(COMMAND)

        client.list_nodes()

        if COMMAND == "EXIT":
            write_log(
                object_id = client.client_id,
                message = f"[X] Client {client.client_id} stopped."
            )
            print("See you soon...")
            sys.exit(0)
except KeyboardInterrupt:
    write_log(
        object_id = client.client_id,
        message = f"[X] Client {client.client_id} stopped."
    )
    write_log(
        object_id = client.client_id,
        message = "[X] Use command EXIT to properly stop the client."
    )
    sys.exit(0)

# TODO: loop through all the nodes printing its information with to_string()
# TODO: add command to turn off a specific node (use the object_id)
# TODO: add command to turn on a specific node (use the object_id)

from src.models.client import Client
from src.models.delivery import Delivery
from src.models.payment import Payment


class Order:

    def __init__(self) -> None:
        self.__id_order = None
        self.__status = None
        self.__created_at = None
        self.__updated_at = None
        self.__id_client = None
        self.__id_delivery = None
        self.__id_payment = None
        self.__client: Client = None
        self.__delivery: Delivery = None
        self.__payment: Payment = None

    @property
    def id_order(self):
        return self.__id_order

    @id_order.setter
    def id_order(self, id_order):
        self.__id_order = id_order

    @property
    def status(self):
        return self.__status

    @status.setter
    def status(self, status):
        self.__status = status

    @property
    def created_at(self):
        return self.__created_at

    @created_at.setter
    def created_at(self, created_at):
        self.__created_at = created_at

    @property
    def updated_at(self):
        return self.__updated_at

    @updated_at.setter
    def updated_at(self, updated_at):
        self.__updated_at = updated_at

    @property
    def id_client(self):
        return self.__id_client

    @id_client.setter
    def id_client(self, id_client):
        self.__id_client = id_client

    @property
    def id_delivery(self):
        return self.__id_delivery

    @id_delivery.setter
    def id_delivery(self, id_delivery):
        self.__id_delivery = id_delivery

    @property
    def id_payment(self):
        return self.__id_payment

    @id_payment.setter
    def id_payment(self, id_payment):
        self.__id_payment = id_payment

    @property
    def client(self):
        return self.__client

    @client.setter
    def client(self, client):
        self.__client = client

    @property
    def delivery(self):
        return self.__delivery

    @delivery.setter
    def delivery(self, delivery):
        self.__delivery = delivery

    @property
    def payment(self):
        return self.__payment

    @payment.setter
    def payment(self, payment):
        self.__payment = payment

    def initialize_from_series(self, data_series):
        """Initializes the object attributes from a pandas Series.
        """
        self.__id_order = data_series['id_order']
        self.__status = data_series['status']
        self.__created_at = data_series['created_at']
        self.__updated_at = data_series['updated_at']
        self.__id_client = data_series['id_client']
        self.__id_delivery = data_series['id_delivery']
        self.__id_payment = data_series['id_payment']

    @property
    def to_dict(self):
        """Returns:
            dict: dictionary with the object attributes.
        """
        return {
            'id_order': self.__id_order,
            'status': self.__status,
            'created_at': self.__created_at,
            'updated_at': self.__updated_at,
            'id_client': self.__id_client,
            'id_delivery': self.__id_delivery,
            'id_payment': self.__id_payment
        }

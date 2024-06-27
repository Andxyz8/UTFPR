from src.operators.datetime_operator import get_str_datetime_from_datetime
from collections import OrderedDict


class Product:
    def __init__(
        self,
        id_product: int = None,
        amount_to_buy: int = None
    ):
        self.__id_product = id_product
        self.__title = None
        self.__price = None
        self.__description = None
        self.__remaining_in_stock = None
        self.__created_at = None
        self.__updated_at = None
        self.__min_for_stock_reposition = None
        self.__amount_to_buy = amount_to_buy

    @property
    def id_product(self):
        """Returns:
            int: product id.
        """
        return self.__id_product

    @id_product.setter
    def id_product(self, id_product: int):
        self.__id_product = id_product

    @property
    def amount_to_buy(self):
        """Returns:
            int: amount to buy.
        """
        return self.__amount_to_buy

    @amount_to_buy.setter
    def amount_to_buy(self, amount: int):
        self.__amount_to_buy = amount

    def initialize_from_series(self, data_series):
        """Initializes the object attributes from a pandas Series.
        """
        self.__id_product = int(data_series['id_product'])
        self.__title = data_series['title']
        self.__price = float(data_series['price'])
        self.__description = data_series['description']
        self.__remaining_in_stock = int(data_series['remaining_in_stock'])
        self.__created_at = get_str_datetime_from_datetime(data_series['created_at'])
        self.__updated_at = get_str_datetime_from_datetime(data_series['updated_at'])
        self.__min_for_stock_reposition = int(data_series['min_remaining_for_stock_reposition'])

    @property
    def to_dict(self):
        """Returns:
            dict: dictionary with the object attributes.
        """
        return {
            'id_product': self.__id_product,
            'title': self.__title,
            'price': self.__price,
            'description': self.__description,
            'remaining_in_stock': self.__remaining_in_stock,
            'created_at': self.__created_at,
            'updated_at': self.__updated_at,
            'min_for_stock_reposition': self.__min_for_stock_reposition
        }

from src.models.product import Product
from src.operators.database_operator import DatabaseOperator
from src.operators.datetime_operator import get_str_datetime_now


class ProductService:

    def __init__(self):
        self.__db_operator = DatabaseOperator()

    def list_products(self):
        list_products = []
        query_select_products = """
            SELECT
                *
            FROM product;
        """

        resp_slt_products = self.__db_operator.executa_select(
            query_select_products
        )
        if resp_slt_products['status'] != 200:
            return resp_slt_products

        df_products = self.__db_operator.df_consulta
        if df_products.empty:
            return {
                'status': 200,
                'message': 'No products found.',
                'products': list_products
            }

        for _, data_series in df_products.iterrows():
            product = Product()
            product.initialize_from_series(data_series)
            list_products.append(product.to_dict)

        return {
            'status': 200,
            'message': 'Products fetched successfully.',
            'products': list_products
        }

    def create_product(self, data: dict):
        str_datetime_now = get_str_datetime_now()
        query_insert_product = f"""
            INSERT INTO product (
                title,
                price,
                description,
                created_at,
                updated_at,
                remaining_in_stock,
                min_remaining_for_stock_reposition
            ) VALUES (
                '{data['title']}',
                {data['price']},
                '{data['description']}',
                TIMESTAMP '{str_datetime_now}',
                TIMESTAMP '{str_datetime_now}',
                {data['remaining_in_stock']},
                {data['min_remaining_for_stock_reposition']}
            ) RETURNING id_product;
        """
        resp_ins_product = self.__db_operator.executa_insert(
            query_insert = query_insert_product,
            return_id = True
        )
        if resp_ins_product['status'] != 200:
            return resp_ins_product

        inserted_product_id = int(self.__db_operator.inserted_id)
        return {
            'status': 201,
            'message': 'Product created successfully.',
            'id_product': inserted_product_id
        }

    def get_product(self, id_product: int):
        """Get the product by its identifier.

        Args:
            id_product (int): product identifier.
        
        Returns:
            dict: dictionary with the status of the operation,
                a message and the product information.
        """
        query_select_product = f"""
            SELECT
                *
            FROM product
            WHERE
                id_product = {id_product};
        """
        resp_slt_product = self.__db_operator.executa_select(
            query_select_product
        )
        if resp_slt_product['status'] != 200:
            return resp_slt_product

        df_product = self.__db_operator.df_consulta
        if df_product.empty:
            return {
                'status': 200,
                'message': 'Product not found.',
                'product': {}
            }

        product = Product()
        product.initialize_from_series(df_product.iloc[0])
        return {
            'status': 200,
            'message': 'Product fetched successfully.',
            'product': product.to_dict
        }

    def update_product(self, id_product: int, data: dict):
        query_update_product = f"""
            UPDATE product
            SET
                title = '{data['title']}',
                price = {data['price']},
                description = '{data['description']}',
                remaining_in_stock = {data['remaining_in_stock']},
                min_remaining_for_stock_reposition = {data['min_remaining_for_stock_reposition']},
                updated_at = TIMESTAMP '{get_str_datetime_now()}'
            WHERE
                id_product = {id_product};
        """
        resp_upd_product = self.__db_operator.executa_update(
            query_update_product
        )
        return resp_upd_product

    def delete_product(self, id_product: int):
        query_delete_product = f"""
            DELETE FROM product
            WHERE
                id_product = {id_product};
        """
        resp_del_product = self.__db_operator.executa_delete(
            query_delete_product
        )
        if resp_del_product['status'] != 200:
            return resp_del_product

        return {
            'status': 200
        }

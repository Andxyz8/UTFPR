from src.operators.database_operator import DatabaseOperator


class CoordinatorService:
    def __init__(self) -> None:
        self.__db_operator = DatabaseOperator()

    def start_transaction(self):
        query_insert_transaction = """
            INSERT INTO purchase_transaction (
                id_purchase_order,
                order_status,
                payment_status,
                delivery_status,
                stock_status,
                observation
            ) VALUES (
                0,
                'N/A',
                'N/A',
                'N/A',
                'N/A',
                'N/A'
            ) RETURNING id_purchase_transaction;
        """
        resp_query = self.__db_operator.executa_insert(
            query_insert_transaction,
            return_id = True
        )

        if resp_query['status'] != 200:
            return resp_query

        txid = int(self.__db_operator.inserted_id)

        return {
            'status': 200,
            'txid': txid
        }

    def continue_transaction(self, txid: int, data: dict):
        for field in data:
            query_update_transaction = f"""
                UPDATE
                    purchase_transaction
                SET
                    {field} = '{data[field]}'
                WHERE
                    id_purchase_transaction = {txid};
            """
            resp_query = self.__db_operator.executa_update(
                query_update_transaction
            )

            if resp_query['status'] != 200:
                return resp_query

        return {
            'status': 200
        }

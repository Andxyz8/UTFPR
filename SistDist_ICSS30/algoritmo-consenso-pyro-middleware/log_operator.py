import datetime


def write_log(object_id: str, message: str):
    """Write log to file.

    Args:
        object_id (str): Object id.
        message (str): Message to write in the log.
    """
    with open(f"{object_id}_log.txt", 'a', encoding='UTF-8') as f:
        f.write(f"{datetime.datetime.now().strftime('%d-%m-%Y %H:%M:%S')} - {message}\n")

from datetime import datetime, timezone, timedelta


def get_str_datetime_now():
    """Returns:
        str: datetime formated as a string YYYY-mm-dd HH:MM:SS.
    """
    return datetime.now(
        tz = timezone(
            offset = timedelta(hours = -3)
        )
    ).strftime('%Y-%m-%d %H:%M:%S')


def get_str_datetime_from_datetime(datetime_obj: datetime):
    """Args:
        datetime_obj (datetime): datetime object.
    
    Returns:
        str: datetime formated as a string YYYY-mm-dd HH:MM:SS.
    """
    return datetime_obj.strftime('%Y-%m-%d %H:%M:%S')

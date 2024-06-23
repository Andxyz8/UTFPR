"""Módulo com funções para manipulação de datas.
"""
from datetime import timezone, timedelta, datetime, date


def date_para_str_date(data: date) -> str:
    """Converte um objeto date para uma string no formato 'YYYY-MM-DD'.

    Args:
        data (date): data a ser convertida.

    Returns:
        str: data no formato 'YYYY-MM-DD'.
    """
    return data.strftime('%Y-%m-%d')


def datetime_para_str_date(data: datetime) -> str:
    """Converte um objeto datetime para uma string no formato 'YYYY-MM-DD'.

    Args:
        data (datetime): data a ser convertida.

    Returns:
        str: data no formato 'YYYY-MM-DD'.
    """
    return data.strftime('%Y-%m-%d')


def datetime_para_str_datetime(data: datetime) -> str:
    """Converte um objeto datetime para uma string no formato 'YYYY-MM-DD HH:MM:SS'.

    Args:
        data (datetime): data a ser convertida.

    Returns:
        str: data no formato 'YYYY-MM-DD HH:MM:SS'.
    """
    return data.strftime('%Y-%m-%d %H:%M:%S')


def obtem_str_datetime_agora() -> str:
    """Retorna a data atual no formato 'YYYY-MM-DD HH:MM:SS'.

    Returns:
        str: data atual no formato 'YYYY-MM-DD HH:MM:SS'.
    """
    # obtem o horário atual no fuso de Brasilia UTC-03:00
    dt_agora_fuso = datetime.now(
        tz = timezone(
            offset = timedelta(hours = -3)
        )
    )
    return datetime_para_str_datetime(dt_agora_fuso)


def obtem_str_date_hoje() -> str:
    """Retorna a data atual no formato 'YYYY-MM-DD'.

    Returns:
        str: data atual no formato 'YYYY-MM-DD'.
    """
    return date_para_str_date(date.today())

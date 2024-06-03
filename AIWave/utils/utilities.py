""" Local modules """
from typing import Dict, List, Tuple


def check_reports(reports: List[Dict[str, str]]) -> Tuple[bool, bool]:
    """
    Check if all the reports has a success status.
    
    Args:
        reports (List[Dict[str, str]]): The reports.
        
    Returns:
        Tuple[bool, bool]: A tuple of booleans. The first boolean indicates if all the reports has a success status. The second boolean indicates if all the reports has an error status.   
        
    Examples:
        >>> check_reports([{'status': 'success'}, {'status': 'success'}])
        (True, False)
    """
    
    # loop through the files_report and check if all has error status
    all_has_error_status = True
    all_has_success_status = True
    for report in reports:
        if report['status'] == 'success':
            all_has_error_status = False
        else:
            all_has_success_status = False
    
    return (all_has_success_status, all_has_error_status)


def format_time(timestamp: str) -> str:
    """
    Format the timestamp.

    Args:
        timestamp (str): The timestamp.

    Returns:
        str: The formatted timestamp.

    Examples:
        >>> format_time('123')
        '00:02:03,000'
    """
    milliseconds = int(timestamp) * 1000
    hours, milliseconds = divmod(milliseconds, 3600000)
    minutes, milliseconds = divmod(milliseconds, 60000)
    seconds, milliseconds = divmod(milliseconds, 1000)

    return f"{hours:02d}:{minutes:02d}:{seconds:02d},{milliseconds:03d}"


def extract_unique_object_names(info: List[Dict[str, str]]) -> List[str]:
    """
    Extract the unique object names from the info.
    
    Args:
        info (List[Dict[str, str]]): The info.
    
    Returns:
        List[str]: The unique object names.
    """
    unique_object_names = set()

    for item in info:
        object_name = item.get('object_name', None)
        if object_name:
            unique_object_names.add(object_name)

    return list(unique_object_names)

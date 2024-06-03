def secure_filename(filename: str) -> str:
    """
    Make a filename safe to use on the filesystem.
    
    Returns:
        A version of the filename that is safe to use on the filesystem.
    """
    # Return the filename with only alphanumeric characters and underscores
    return ''.join(c for c in filename if c.isalnum() or c == '_')

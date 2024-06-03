import os
import shutil
import subprocess

# Define paths to the temp and output folders
folders = [
    './instance',
    './storage',
    './temp',
    './models'
]

# TypeError: ResultWriter.__call__() missing 1 required positional argument: 'options'

# Function to remove folder
def remove_folder(folder_path: str) -> None:
    """
    Function to remove a folder and all its contents.

    Args:
        folder_path (str): Path to the folder to be removed.

    Returns:
        None
    """
    try:
        # Remove the folder and all its contents
        shutil.rmtree(folder_path)
        print(f"Removed folder {folder_path}")
    except FileNotFoundError:
        pass
    except Exception as e:
        print(f"Error removing folder {folder_path}: {e}")

def remove_log_folders():
    try:
        # Replace 'your_flask_script.py' with the name of your Flask script
        subprocess.run(['python', './logs/remove_log_folders.py'])
    except Exception as e:
        print(f"Error restarting the Flask server: {str(e)}")

def drop_db():
    from database.local_db import drop_tables
    
    try:
        drop_tables()
    except Exception as e:
        print(f"Error dropping the database: {str(e)}")

def restart_server():
    try:
        # Replace 'your_venv\Scripts\activate' with the path to your virtual environment's activate script
        venv_activate_script = 'venv\\Scripts\\activate'

        # Activate the virtual environment and run the Flask script
        activate_command = f'cmd /k "{venv_activate_script} && python app.py"'
        subprocess.run(activate_command, shell=True, executable='C:\\Windows\\System32\\cmd.exe')
    except Exception as e:
        print(f"Error restarting the Flask server: {str(e)}")

# Main function
if __name__ == '__main__':
    
    for folder in folders:
        remove_folder(folder)
    
    remove_log_folders()
    drop_db()
    restart_server()

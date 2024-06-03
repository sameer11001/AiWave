""" Built-in modules """
import os
import argparse

""" Third-party modules """
from dotenv import load_dotenv

""" Local modules """
from logs import CustomLogger
from enums import Environment

logger = CustomLogger("Main")


def parse_args() -> argparse.Namespace:
    """
    Parse the command line arguments.
    
    Args:
        None
    
    Returns:
        argparse.Namespace: The parsed arguments.
    """
    parser = argparse.ArgumentParser(description="Run the app in different modes.")
    parser.add_argument("-p", "--production", action="store_true", help="Run in production mode.")
    parser.add_argument("-d", "--development", action="store_true", help="Run in development mode.")
    parser.add_argument("-t", "--testing", action="store_true", help="Run in testing mode.")
    return parser.parse_args()

def select_environment(args: argparse.Namespace) -> Environment:
    """
    Select the environment to run the app in.
    
    Args:
        args (argparse.Namespace): The parsed arguments.
    
    Returns:
        Environment: The environment to run the app in.
    """
    from config import WaveConfig
    if args.production:
        env = Environment.PRODUCTION
    elif args.testing:
        env = Environment.TESTING
    else:
        env = Environment.DEVELOPMENT
    
    logger.info(f"[OK].Running in {env.value} mode...")
    
    WaveConfig.set_instance(env=env)
    return env

# Parse the command line arguments
args = parse_args()

# Select the environment to run the app in
env = select_environment(args=args)

# Load default environment variables
load_dotenv()

print("[0-o].Loading dependencies...")
from flask_app import create_app
from flask_app.server_info import ServerInfo

def main() -> None:
    """
    Main function to run the app server.
    
    Args:
        None
    
    Returns:
        None
    
    Raises:
        If the server could not be started.
    """
    # Create the Flask app using the specified environment
    app = create_app(env=env)
    
    # Push the app context to the app
    app.app_context().push()

    try:
        logger.info("[OK].Starting server...")
        # Set the app in the server info.
        ServerInfo.app = app
        
        # Check if GOOGLE_API_KEY is set.
        if not os.getenv("GOOGLE_API_KEY"):
            raise Exception("GOOGLE_API_KEY is not set. Please set it in the `.env` file. See README.md for more information.")
        
        # Run the app on all available interfaces on port 7651 (default).
        app.run(
            host=ServerInfo.host,
            port=ServerInfo.port,
            load_dotenv=True,
        )
    except Exception as e:
        logger.error(f"[ERROR].{e}")
        logger.error("[ERROR].Server could not be started.")

if __name__ == "__main__":
    main()

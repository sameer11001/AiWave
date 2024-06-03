""" Built-in modules """
import json

""" Third-party modules """
import redis
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

""" Local modules """
from config import WaveConfig

def create_users_for_test(num: int = 10):
    """
    Create test users for testing purposes.
    
    Args:
        num (int): The number of users to create.
    
    Returns:
        None
    
    Raises:
        None
    """
    try:
        import random
        from enums import Role
        from database.local_db.models.user.add_user import AddUser
        from database.local_db.models.user.retrieve_user import GetUserData
        
        for i in range(num):
            uid = f'test_{i}'
            user = GetUserData().get_user_by_uid(uid)
            if user is None:
                # Create a new AddUser instance with the admin credentials
                add_user = AddUser(
                    uid         = uid,
                    email       = f'test{i}@example.com',
                    password    = f'Password{i}@',
                    username    = f'test{i}',
                    image_url   = f'https://picsum.photos/id/23{i}/300/300',
                    age         = random.randint(18, 30),
                    role        = Role.ADMIN.value if i == 0 or i == 1 else Role.USER.value,
                    data={
                        'test': 'test',
                    }
                )
                
                # Insert the user into the database
                add_user.insert_user()
        
    except Exception as e:
        pass    
                
def create_admin_account():
    """
    Create the admin account.
    
    Args:
        None
        
    Returns:
        None
    
    Raises:
        None
    """
    try:
        from enums import Role
        from database.local_db.models.user.add_user import AddUser
        from database.local_db.models.user.retrieve_user import GetUserData
        
        # Check if the admin account already exists
        admin = GetUserData().get_user_by_uid('x')
        if admin is None:
            # Create a new AddUser instance with the admin credentials
            add_user = AddUser(
                uid='x',
                email='admin@admin.com',
                password='Ma123456@',
                username='admin',
                image_url='https://images.pexels.com/photos/9668535/pexels-photo-9668535.jpeg?auto=compress&cs=tinysrgb&w=1600',
                age=22,
                role=Role.ADMIN.value,
            )

            # Insert the user into the database
            add_user.insert_user()
    except Exception as e:
        pass

engine = create_engine(WaveConfig.instance.SQLALCHEMY_DATABASE_URI)

# Define the Base class for SQLAlchemy models
Base = declarative_base()

Session = sessionmaker(bind=engine)

r = redis.Redis(
    host    = WaveConfig.instance.REDIS_HOST,
    port    = WaveConfig.instance.REDIS_PORT, 
)

class RedisSession:
    """
    A class that represents a Redis session.
    """
    def __init__(self) -> None:
        """
        Initialize the RedisSession instance with input values.
        
        Args:
            key (str): The key of the session.
            value (str): The value of the session.
        
        Returns:
            None
        
        Raises:
            None
        """
        pass
    
    def add(self, key:str, data: any) -> None:
        """
        Set the session in Redis.
        
        Args:
            key (str): The key of the session.
            data (any): The data of the session.
        
        Returns:
            None
        
        Raises:
            None
        """
        if isinstance(data, dict):
            data = json.dumps(data)
            
        r.set(key, data)
    
    def get(self, key: str) -> any:
        """
        Get the session from Redis.
        
        Args:
            key (str): The key of the session.
        
        Returns:
            str: The session.
        
        Raises:
            None
        """
        data = json.loads(r.get(key))
        return data
    
    def update(self, key:str, data: any) -> None:
        """
        Update the session in Redis.
        
        Args:
            key (str): The key of the session.
            data (any): The data of the session.
        
        Returns:
            None
        
        Raises:
            None
        """
        if isinstance(data, dict):
            data = json.dumps(data)
            
        r.set(key, data)
    
    def delete(self, key:str) -> None:
        """
        Delete the session from Redis.
        
        Args:
            key (str): The key of the session.
        
        Returns:
            None
        
        Raises:
            None
        """
        r.delete(key)

    def commit(self) -> None:
        """
        Commit the session.
        
        Args:
            None
        
        Returns:
            None
        
        Raises:
            None
        """
        pass

    def close(self) -> None:
        """
        Close the Redis session.
        
        Args:
            None
        
        Returns:
            None
        
        Raises:
            None
        """
        pass


def create_tables():
    """
    Create the database tables if they don't exist.
    
    Args:
        None
    
    Returns:
        None
    """
    # Create the database tables
    Base.metadata.create_all(bind=engine)
    # Create the admin account
    create_admin_account()
    # Create test users
    create_users_for_test()

def drop_tables():
    """
    Drop the database tables.
    
    Args:
        None
    
    Returns:
        None
    """
    # Drop the database tables
    Base.metadata.drop_all(bind=engine)


__all__ = [
    'r'
    'Base'
    'Session',
    'drop_tables',
    'RedisSession',
    'create_tables',
]

class ProductionConfig:
    DEBUG = False
    SECRET_KEY = "f7d70cdd4657ed7b71fa89914172c04913ff8da2bcf3f64514db464028f08912"
    
    # Database configuration settings
    __db_host = 'postgres-container' # Use Docker container name
    __db_port = '5432'
    __db_name = 'wavebase'
    __db_user = 'postgres'
    __db_password = 'pass'
    #                                       <username>:<password>@<host>:<port>/<database_name>
    SQLALCHEMY_DATABASE_URI = f'postgresql://{__db_user}:{__db_password}@{__db_host}:{__db_port}/{__db_name}'
    SQLALCHEMY_TRACK_MODIFICATIONS = False  # Disable modification tracking for SQLAlchemy

    # Redis configuration settings
    REDIS_HOST = 'redis-container' # Use Docker container name
    REDIS_PORT = 6379
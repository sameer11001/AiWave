class DevelopmentConfig:
    DEBUG = True
    SECRET_KEY = "f7a0fa25ececdd733c6b8b5376f14bc61e0a71e7e44c7224143d89ff4719a4c9"
    
    # Database configuration settings
    __db_host = 'localhost' # Use local postgres
    __db_port = '5432'
    __db_name = 'wavebase'
    __db_user = 'postgres'
    __db_password = '1234'
    #                                       <username>:<password>@<host>:<port>/<database_name>
    SQLALCHEMY_DATABASE_URI = f'postgresql://{__db_user}:{__db_password}@{__db_host}:{__db_port}/{__db_name}'
    SQLALCHEMY_TRACK_MODIFICATIONS = False  # Disable modification tracking for SQLAlchemy
    
    # Redis configuration settings
    REDIS_HOST = 'localhost'
    REDIS_PORT = 6379

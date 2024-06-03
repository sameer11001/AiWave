class TestingConfig:
    DEBUG = True
    TESTING = True
    SECRET_KEY = "ade347c919c38f06eab90e1762c47aa7d2c81f2579f1f150d235198b856e9fc0"
    
    # Database configuration settings
    DATABASE_DIR = './instance'
    SQLALCHEMY_DATABASE_URI = f'sqlite:///{DATABASE_DIR}/wavebase.db' # Use SQLite in testing
    SQLALCHEMY_TRACK_MODIFICATIONS = False  # Disable modification tracking for SQLAlchemy

    # Redis configuration settings
    REDIS_HOST = 'localhost'
    REDIS_PORT = 6379
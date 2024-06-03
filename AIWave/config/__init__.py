""" Built-in modules """
from typing import Union

""" Local modules """
from config.testing import TestingConfig
from enums import Environment
from config.production import ProductionConfig
from config.development import DevelopmentConfig



class WaveConfig:
    
    instance: Union[DevelopmentConfig, ProductionConfig, TestingConfig] = DevelopmentConfig
    
    @classmethod
    def set_instance(cls, env: Environment.DEVELOPMENT) -> None:
        """
        Set the instance of the BaseConfig class based on the environment.
        
        Args:
            env (Environment): The environment to configure the application.
        
        Returns:
            None
        """
        if env == Environment.DEVELOPMENT:
            cls.instance = DevelopmentConfig
        elif env == Environment.PRODUCTION:
            cls.instance = ProductionConfig
        elif env == Environment.TESTING:
            cls.instance = TestingConfig
        else:
            raise ValueError(f"Invalid environment '{env}'. Please use one of: Environment.DEVELOPMENT, Environment.PRODUCTION, or Environment.TESTING.")


__all__ = [
    'Environment',
    'WaveConfig',
    'DevelopmentConfig',
    'ProductionConfig',
    'TestingConfig'
]

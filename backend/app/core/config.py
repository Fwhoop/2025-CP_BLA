from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    jwt_secret: str
    port: int = 8000
    debug: bool = True

    mysql_root_password: str | None = None
    mysql_database: str | None = None
    mysql_user: str | None = None
    mysql_password: str | None = None

    class Config:
        env_file = ".env"

settings = Settings()

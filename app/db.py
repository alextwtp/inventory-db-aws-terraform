import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from test_secret import get_db_secret

# Get AWS Secrets Manager credentials
db_config = get_db_secret()

DB_USER = db_config["DB_USER"]
DB_PASSWORD = db_config["DB_PASSWORD"]
DB_HOST = db_config["DB_HOST"]
DB_PORT = db_config["DB_PORT"]
DB_NAME = db_config["DB_NAME"]

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL, echo=True) 
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
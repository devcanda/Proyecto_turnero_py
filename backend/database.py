from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy.exc import OperationalError
import time

SQLALCHEMY_DATABASE_URL = "mysql+pymysql://turnero_user:1ng3n13r%40s%26st3m%40s@db:3306/turnero_db"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def init_db():
    """Intenta conectar a la base de datos repetidamente hasta que MariaDB esté lista."""
    max_retries = 10
    for i in range(max_retries):
        try:
            # Intenta crear las tablas (lo que prueba la conexión real)
            Base.metadata.create_all(bind=engine)
            print("Conexión a MariaDB exitosa y tablas verificadas.")
            return
        except OperationalError:
            print(f"MariaDB no está lista. Reintentando en 3 segundos... (Intento {i+1}/{max_retries})")
            time.sleep(3)
    
    # Si después de 10 intentos falla, entonces sí dejamos que falle
    raise Exception("No se pudo conectar a la base de datos después de varios reintentos.")

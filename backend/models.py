from sqlalchemy import Column, Integer, String, ForeignKey
from database import Base

class Paciente(Base):
    __tablename__ = "pacientes"
    id = Column(Integer, primary_key=True, index=True)
    tipo_doc = Column(String(10), default="CC")
    numero_identificacion = Column(String(50), unique=True, index=True)
    nombre = Column(String(150))

class Turno(Base):
    __tablename__ = "turnos"
    id = Column(Integer, primary_key=True, index=True)
    paciente_id = Column(Integer, ForeignKey("pacientes.id"))
    servicio = Column(String(50))
    nomenclatura = Column(String(10))
    numero_turno = Column(Integer)
    estado = Column(String(20), default="EN_ESPERA")

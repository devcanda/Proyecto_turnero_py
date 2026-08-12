from sqlalchemy import Column, Integer, String, Boolean, Enum, ForeignKey
from database import Base

class Paciente(Base):
    __tablename__ = "pacientes"

    id = Column(Integer, primary_key=True, index=True)
    tipo_doc = Column(Enum('C.C', 'T.I', 'C.E', 'P.A', 'R.C'), default='C.C', nullable=False)
    numero_identificacion = Column(String(50), unique=True, index=True, nullable=False)
    nombre = Column(String(100), nullable=False)
    embarazo = Column(Boolean, default=False)

class Servicio(Base):
    __tablename__ = "servicios"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    estado = Column(Enum('ACTIVO', 'INACTIVO'), default='ACTIVO')
    categoria = Column(String(50), nullable=True)
    visible = Column(Enum('SI', 'NO'), default='NO')
    categoria_id = Column(Integer, nullable=True)

class Turno(Base):
    __tablename__ = "turnos"

    id = Column(Integer, primary_key=True, index=True)
    paciente_id = Column(Integer, ForeignKey("pacientes.id"), nullable=False)
    servicio = Column(String(50), nullable=False)
    nomenclatura = Column(String(20), nullable=False)
    numero_turno = Column(Integer, nullable=False)
    estado = Column(String(32), default='EN_ESPERA')

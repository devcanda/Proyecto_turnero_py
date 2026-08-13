from pydantic import BaseModel

class PacienteBase(BaseModel):
    tipo_doc: str
    numero_identificacion: str
    nombre: str

class PacienteCreate(PacienteBase):
    pass

class Paciente(PacienteBase):
    id: int
    class Config:
        from_attributes = True

class TurnoBase(BaseModel):
    servicio: str
    nomenclatura: str
    numero_turno: int

class TurnoCreate(TurnoBase):
    paciente_id: int

class Turno(TurnoBase):
    id: int
    paciente_id: int
    estado: str
    class Config:
        from_attributes = True

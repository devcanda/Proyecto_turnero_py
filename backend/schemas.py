from pydantic import BaseModel

class PacienteBase(BaseModel):
    tipo_doc: str
    numero_identificacion: str
    nombre: str
    embarazo: bool = False

class PacienteCreate(PacienteBase):
    pass

class Paciente(PacienteBase):
    id: int

    class Config:
        from_attributes = True

class TurnoBase(BaseModel):
    paciente_id: int
    servicio: str
    nomenclatura: str
    numero_turno: int

class TurnoCreate(TurnoBase):
    pass

class Turno(TurnoBase):
    id: int
    estado: str

    class Config:
        from_attributes = True

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

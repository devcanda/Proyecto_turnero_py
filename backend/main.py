from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import engine, get_db
import models, schemas

# Crea las tablas si no existen
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="API Turnero Digital", version="1.0.0")

@app.get("/")
def read_root():
    return {"mensaje": "Backend conectado. Listo para procesar turnos."}

@app.post("/pacientes/", response_model=schemas.Paciente, tags=["Pacientes"])
def crear_paciente(paciente: schemas.PacienteCreate, db: Session = Depends(get_db)):
    db_paciente = db.query(models.Paciente).filter(models.Paciente.numero_identificacion == paciente.numero_identificacion).first()
    if db_paciente:
        raise HTTPException(status_code=400, detail="El documento del paciente ya está registrado")
    
    nuevo_paciente = models.Paciente(**paciente.model_dump())
    db.add(nuevo_paciente)
    db.commit()
    db.refresh(nuevo_paciente)
    return nuevo_paciente

@app.get("/pacientes/", response_model=list[schemas.Paciente], tags=["Pacientes"])
def obtener_pacientes(db: Session = Depends(get_db)):
    return db.query(models.Paciente).all()

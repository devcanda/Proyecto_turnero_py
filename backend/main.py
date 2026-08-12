from fastapi import FastAPI, Depends, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from database import engine, get_db, init_db
import models, schemas
from socket_manager import manager

# Usamos nuestra nueva función a prueba de fallos
init_db()

app = FastAPI(title="API Turnero Digital", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- RUTAS DE PACIENTES ---
@app.post("/pacientes/", response_model=schemas.Paciente, tags=["Pacientes"])
def crear_paciente(paciente: schemas.PacienteCreate, db: Session = Depends(get_db)):
    db_paciente = db.query(models.Paciente).filter(models.Paciente.numero_identificacion == paciente.numero_identificacion).first()
    if db_paciente:
        raise HTTPException(status_code=400, detail="El documento ya está registrado")
    
    nuevo_paciente = models.Paciente(**paciente.model_dump())
    db.add(nuevo_paciente)
    db.commit()
    db.refresh(nuevo_paciente)
    return nuevo_paciente

@app.get("/pacientes/", response_model=list[schemas.Paciente], tags=["Pacientes"])
def obtener_pacientes(db: Session = Depends(get_db)):
    return db.query(models.Paciente).all()

# --- RUTAS DE TURNOS Y WEBSOCKET ---
@app.post("/turnos/", response_model=schemas.Turno, tags=["Turnos"])
async def crear_turno(turno: schemas.TurnoCreate, db: Session = Depends(get_db)):
    nuevo_turno = models.Turno(**turno.model_dump())
    db.add(nuevo_turno)
    db.commit()
    db.refresh(nuevo_turno)
    
    evento = {
        "accion": "NUEVO_TURNO",
        "datos": {
            "id": nuevo_turno.id,
            "nomenclatura": nuevo_turno.nomenclatura,
            "numero": nuevo_turno.numero_turno,
            "servicio": nuevo_turno.servicio
        }
    }
    await manager.broadcast(evento)
    return nuevo_turno

@app.websocket("/ws/pantalla")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket)

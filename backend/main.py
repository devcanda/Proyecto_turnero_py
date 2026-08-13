from fastapi import FastAPI, Depends, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
from database import engine, get_db, init_db
import models, schemas
from socket_manager import manager

init_db()

app = FastAPI(title="API Turnero Digital", version="1.0.0")

@app.on_event("startup")
def upgrade_db():
    try:
        with engine.begin() as conn:
            conn.execute(text("ALTER TABLE pacientes ADD COLUMN tipo_doc VARCHAR(10) DEFAULT 'CC'"))
    except Exception:
        pass

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

# --- RUTAS DE TURNOS ---
@app.post("/turnos/", response_model=schemas.Turno, tags=["Turnos"])
async def crear_turno(turno: schemas.TurnoCreate, db: Session = Depends(get_db)):
    nuevo_turno = models.Turno(**turno.model_dump())
    db.add(nuevo_turno)
    db.commit()
    db.refresh(nuevo_turno)
    return nuevo_turno

@app.get("/turnos/pendientes", response_model=list[schemas.Turno], tags=["Turnos"])
def obtener_turnos_pendientes(db: Session = Depends(get_db)):
    return db.query(models.Turno).filter(models.Turno.estado == 'EN_ESPERA').all()

# NUEVO ENDPOINT: Historial de los últimos llamados para encendido de pantallas
@app.get("/turnos/llamados", response_model=list[schemas.Turno], tags=["Turnos"])
def obtener_turnos_llamados(db: Session = Depends(get_db)):
    return db.query(models.Turno).filter(models.Turno.estado == 'LLAMADO').order_by(models.Turno.id.desc()).limit(5).all()

@app.put("/turnos/{turno_id}/llamar", response_model=schemas.Turno, tags=["Turnos"])
async def llamar_turno(turno_id: int, db: Session = Depends(get_db)):
    turno = db.query(models.Turno).filter(models.Turno.id == turno_id).first()
    if not turno:
        raise HTTPException(status_code=404, detail="Turno no encontrado")
    
    turno.estado = 'LLAMADO'
    db.commit()
    db.refresh(turno)
    
    evento = {
        "accion": "NUEVO_TURNO",
        "datos": {
            "id": turno.id,
            "nomenclatura": turno.nomenclatura,
            "numero": turno.numero_turno,
            "servicio": turno.servicio
        }
    }
    await manager.broadcast(evento)
    return turno

# --- WEBSOCKET ---
@app.websocket("/ws/pantalla")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket)

from fastapi import FastAPI

app = FastAPI(title="API Turnero Digital")

@app.get("/")
def read_root():
    return {"mensaje": "¡El backend en Python está vivo y funcionando en el puerto 8100!"}# Entrypoint del backend

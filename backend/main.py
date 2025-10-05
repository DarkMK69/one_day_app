from fastapi import FastAPI
from app.database import engine, Base
from app.routes import auth, orders, services, pvz, users
from fastapi.middleware.cors import CORSMiddleware

# Создаем таблицы в базе данных
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Repair Service Platform",
    description="Платформа для ремонта техники и химчистки",
    version="1.0.0"
)

# Настройка CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # В продакшене заменить на конкретные домены
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Подключаем роутеры
app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(orders.router, prefix="/orders", tags=["orders"])
app.include_router(services.router, prefix="/services", tags=["services"])
app.include_router(pvz.router, prefix="/pvz", tags=["pvz"])

@app.get("/")
async def root():
    return {"message": "Repair Service Platform API", "status": "running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "database": "connected"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
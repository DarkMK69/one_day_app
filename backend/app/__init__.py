from fastapi import FastAPI
from .database import engine, Base
from .routes import auth, orders, services, pvz, users

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Repair Service Platform", version="1.0.0")

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(orders.router, prefix="/orders", tags=["orders"])
app.include_router(services.router, prefix="/services", tags=["services"])
app.include_router(pvz.router, prefix="/pvz", tags=["pvz"])
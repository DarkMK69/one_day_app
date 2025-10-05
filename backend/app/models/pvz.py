from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from ..database import Base

class PVZ(Base):
    __tablename__ = "pvz"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    address = Column(String(300), nullable=False)
    latitude = Column(String(20), nullable=True)
    longitude = Column(String(20), nullable=True)
    working_hours = Column(String(100), nullable=False)
    operator_name = Column(String(100), nullable=True)
    operator_phone = Column(String(15), nullable=True)
    accepts_tech = Column(Boolean, default=False)
    accepts_clothing = Column(Boolean, default=False)
    accepts_shoes = Column(Boolean, default=False)
    unique_id = Column(String(20), unique=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    orders = relationship("Order", back_populates="pvz")

# Добавляем relationship в Order модель
from .order import Order
Order.pvz = relationship("PVZ", back_populates="orders")
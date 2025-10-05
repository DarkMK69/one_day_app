from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, Float, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from ..database import Base

class Review(Base):
    __tablename__ = "reviews"
    
    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("orders.id"))
    service_id = Column(Integer, ForeignKey("services.id"))
    rating = Column(Integer, nullable=False)  # 1-5
    text = Column(Text, nullable=True)
    is_anonymous = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    order = relationship("Order", back_populates="reviews")
    service = relationship("Service", back_populates="reviews")

# Добавляем relationship в Order и Service модели
from .order import Order
from .service import Service
Order.reviews = relationship("Review", back_populates="order")
Service.reviews = relationship("Review", back_populates="service")
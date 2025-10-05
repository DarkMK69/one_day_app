from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, Float, ForeignKey, Enum as SQLEnum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import enum
from ..database import Base

class OrderStatus(enum.Enum):
    CREATED = "created"
    ACCEPTED = "accepted"
    SENT_TO_SERVICE = "sent_to_service"
    DIAGNOSING = "diagnosing"
    PRICE_PROPOSED = "price_proposed"
    CONFIRMED = "confirmed"
    REJECTED = "rejected"
    IN_WORK = "in_work"
    READY = "ready"
    READY_FOR_PICKUP = "ready_for_pickup"
    DELIVERED = "delivered"

class ServiceType(enum.Enum):
    TECH = "tech"
    CLOTHING = "clothing"
    SHOES = "shoes"

class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    unique_id = Column(String(20), unique=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    service_id = Column(Integer, ForeignKey("services.id"), nullable=True)
    pvz_id = Column(Integer, ForeignKey("pvz.id"))
    
    service_type = Column(SQLEnum(ServiceType), nullable=False)
    subcategory = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    photos = Column(Text)  # JSON список фото URLs
    
    price_limit = Column(Float, nullable=True)
    final_price = Column(Float, nullable=True)
    price_justification = Column(Text, nullable=True)
    
    status = Column(SQLEnum(OrderStatus), default=OrderStatus.CREATED)
    payment_method = Column(String(20), default="online")  # online/cash
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    user = relationship("User", back_populates="orders")
    service = relationship("Service", back_populates="orders")
    pvz = relationship("PVZ", back_populates="orders")
    reviews = relationship("Review", back_populates="order")

# Добавляем relationship в User модель
from models import User
User.orders = relationship("Order", back_populates="user")
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, Float, Enum as SQLEnum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import enum
from ..database import Base

class ServiceType(enum.Enum):
    TECH_REPAIR = "tech_repair"
    DRY_CLEANING = "dry_cleaning"
    ATELIER = "atelier"
    SHOES_REPAIR = "shoes_repair"

class ServiceStatus(enum.Enum):
    PENDING = "pending"
    VERIFIED = "verified"
    REJECTED = "rejected"

class Service(Base):
    __tablename__ = "services"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    inn = Column(String(12), unique=True, nullable=False)
    service_type = Column(SQLEnum(ServiceType), nullable=False)
    description = Column(Text, nullable=True)
    contact_phone = Column(String(15), nullable=False)
    contact_email = Column(String(100), nullable=False)
    rating = Column(Float, default=0.0)
    review_count = Column(Integer, default=0)
    status = Column(SQLEnum(ServiceStatus), default=ServiceStatus.PENDING)
    bank_details = Column(Text, nullable=True)
    service_zone = Column(Text, nullable=True)  # JSON с геозоной
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    orders = relationship("Order", back_populates="service")
    reviews = relationship("Review", back_populates="service")
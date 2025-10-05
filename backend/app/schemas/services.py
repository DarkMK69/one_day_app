from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from ..models.service import ServiceType, ServiceStatus

class ServiceBase(BaseModel):
    name: str
    inn: str
    service_type: ServiceType
    description: Optional[str] = None
    contact_phone: str
    contact_email: str
    bank_details: Optional[str] = None
    service_zone: Optional[str] = None

class ServiceCreate(ServiceBase):
    pass

class Service(ServiceBase):
    id: int
    rating: float
    review_count: int
    status: ServiceStatus
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
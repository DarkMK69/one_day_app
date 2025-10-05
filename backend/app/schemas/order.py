from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from ..models.order import OrderStatus, ServiceType

class OrderBase(BaseModel):
    service_type: ServiceType
    subcategory: str
    description: str
    photos: Optional[str] = None
    price_limit: Optional[float] = None
    payment_method: str = "online"

class OrderCreate(OrderBase):
    user_id: int
    pvz_id: int

class OrderResponse(OrderBase):
    id: int
    unique_id: str
    user_id: int
    pvz_id: int
    service_id: Optional[int] = None
    status: OrderStatus
    final_price: Optional[float] = None
    price_justification: Optional[str] = None
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
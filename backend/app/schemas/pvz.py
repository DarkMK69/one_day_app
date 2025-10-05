from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class PVZBase(BaseModel):
    name: str
    address: str
    latitude: Optional[str] = None
    longitude: Optional[str] = None
    working_hours: str
    operator_name: Optional[str] = None
    operator_phone: Optional[str] = None
    accepts_tech: bool = False
    accepts_clothing: bool = False
    accepts_shoes: bool = False

class PVZCreate(PVZBase):
    unique_id: str

class PVZ(PVZBase):
    id: int
    unique_id: str
    created_at: datetime

    class Config:
        from_attributes = True
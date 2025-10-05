from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..models.service import Service, ServiceStatus
from ..schemas.service import ServiceCreate, Service as ServiceSchema

router = APIRouter()

@router.get("/", response_model=list[ServiceSchema])
def get_services(db: Session = Depends(get_db)):
    services = db.query(Service).filter(Service.status == ServiceStatus.VERIFIED).all()
    return services

@router.post("/", response_model=ServiceSchema)
def create_service(service: ServiceCreate, db: Session = Depends(get_db)):
    db_service = Service(**service.dict())
    db.add(db_service)
    db.commit()
    db.refresh(db_service)
    return db_service

@router.get("/{service_id}", response_model=ServiceSchema)
def get_service(service_id: int, db: Session = Depends(get_db)):
    service = db.query(Service).filter(Service.id == service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Сервис не найден")
    return service
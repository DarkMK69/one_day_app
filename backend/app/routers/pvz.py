from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from ..models.pvz import PVZ
from ..schemas.pvz import PVZ as PVZSchema

router = APIRouter()

@router.get("/", response_model=list[PVZSchema])
def get_pvz_list(db: Session = Depends(get_db)):
    pvz_list = db.query(PVZ).all()
    return pvz_list

@router.get("/nearby")
def get_nearby_pvz(lat: float, lng: float, service_type: str = None, db: Session = Depends(get_db)):
    # Упрощенная логика - возвращаем все ПВЗ
    # В реальном приложении добавить расчет расстояния
    pvz_list = db.query(PVZ).all()
    
    if service_type:
        if service_type == "tech":
            pvz_list = [pvz for pvz in pvz_list if pvz.accepts_tech]
        elif service_type == "clothing":
            pvz_list = [pvz for pvz in pvz_list if pvz.accepts_clothing]
        elif service_type == "shoes":
            pvz_list = [pvz for pvz in pvz_list if pvz.accepts_shoes]
    
    return pvz_list
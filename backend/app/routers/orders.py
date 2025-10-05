from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..models.order import Order, OrderStatus, ServiceType
from ..schemas.order import OrderCreate, OrderResponse
import shortuuid

router = APIRouter()

def generate_order_id():
    return f"ORD-{shortuuid.ShortUUID().random(length=8).upper()}"

@router.post("/", response_model=OrderResponse)
def create_order(order: OrderCreate, db: Session = Depends(get_db)):
    db_order = Order(
        unique_id=generate_order_id(),
        user_id=order.user_id,
        pvz_id=order.pvz_id,
        service_type=order.service_type,
        subcategory=order.subcategory,
        description=order.description,
        photos=order.photos,
        price_limit=order.price_limit,
        payment_method=order.payment_method,
        status=OrderStatus.CREATED
    )
    
    db.add(db_order)
    db.commit()
    db.refresh(db_order)
    return db_order

@router.get("/{order_id}", response_model=OrderResponse)
def get_order(order_id: int, db: Session = Depends(get_db)):
    order = db.query(Order).filter(Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Заказ не найден")
    return order

@router.put("/{order_id}/status")
def update_order_status(order_id: int, status: OrderStatus, db: Session = Depends(get_db)):
    order = db.query(Order).filter(Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Заказ не найден")
    
    order.status = status
    db.commit()
    return {"message": "Статус обновлен"}
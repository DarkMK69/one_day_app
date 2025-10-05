from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from ..database import get_db
from ..models.user import User
from ..schemas.auth import SMSRequest, SMSVerify
import random
import os
import requests

router = APIRouter()

# Мок сервиса SMS (в продакшене заменить на реальный)
def send_sms_code(phone: str, code: str):
    print(f"SMS код для {phone}: {code}")  # Для разработки
    return True

@router.post("/request-sms")
async def request_sms(request: SMSRequest, db: Session = Depends(get_db)):
    # Генерируем 4-значный код
    code = str(random.randint(1000, 9999))
    
    # Сохраняем код в базе (упрощённо)
    user = db.query(User).filter(User.phone == request.phone).first()
    if not user:
        user = User(phone=request.phone)
        db.add(user)
    
    # В реальном приложении сохраняем код с временем жизни
    send_sms_code(request.phone, code)
    
    return {"message": "SMS отправлен", "code": code}  # В продакшене не возвращаем код

@router.post("/verify-sms")
async def verify_sms(request: SMSVerify, db: Session = Depends(get_db)):
    # Упрощённая верификация - в реальном приложении проверять код из базы
    user = db.query(User).filter(User.phone == request.phone).first()
    if not user:
        raise HTTPException(status_code=404, detail="Пользователь не найден")
    
    # Генерируем JWT токен
    from ..auth import create_access_token
    access_token = create_access_token(data={"sub": user.phone, "user_id": user.id})
    
    return {"access_token": access_token, "token_type": "bearer", "user": user}
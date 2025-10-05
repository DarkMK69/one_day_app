from pydantic import BaseModel

class SMSRequest(BaseModel):
    phone: str

class SMSVerify(BaseModel):
    phone: str
    code: str
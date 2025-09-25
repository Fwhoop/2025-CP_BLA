from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime

from .. import models, schemas
from ..db import get_db

router = APIRouter(prefix="/chats", tags=["chats"])


@router.post("/", response_model=schemas.ChatRead)
def create_chat(chat: schemas.ChatCreate, db: Session = Depends(get_db)):
    sender = db.query(models.User).filter(models.User.id == chat.sender_id).first()
    receiver = db.query(models.User).filter(models.User.id == chat.receiver_id).first()
    if not sender or not receiver:
        raise HTTPException(status_code=404, detail="Sender or receiver not found")

    new_chat = models.Chat(
        sender_id=chat.sender_id,
        receiver_id=chat.receiver_id,
        message=chat.message,
        created_at=datetime.utcnow()
    )

    db.add(new_chat)
    db.commit()
    db.refresh(new_chat)
    return new_chat


@router.get("/", response_model=List[schemas.ChatRead])
def get_all_chats(db: Session = Depends(get_db)):
    return db.query(models.Chat).all()


@router.get("/{chat_id}", response_model=schemas.ChatRead)
def get_chat(chat_id: int, db: Session = Depends(get_db)):
    chat = db.query(models.Chat).filter(models.Chat.id == chat_id).first()
    if not chat:
        raise HTTPException(status_code=404, detail="Chat not found")
    return chat


@router.get("/user/{user_id}", response_model=List[schemas.ChatRead])
def get_chats_by_user(user_id: int, db: Session = Depends(get_db)):
    chats = db.query(models.Chat).filter(
        (models.Chat.sender_id == user_id) | (models.Chat.receiver_id == user_id)
    ).all()
    return chats


@router.delete("/{chat_id}")
def delete_chat(chat_id: int, db: Session = Depends(get_db)):
    chat = db.query(models.Chat).filter(models.Chat.id == chat_id).first()
    if not chat:
        raise HTTPException(status_code=404, detail="Chat not found")

    db.delete(chat)
    db.commit()
    return {"detail": "Chat deleted successfully"}

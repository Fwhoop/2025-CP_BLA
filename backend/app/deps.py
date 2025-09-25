from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from .db import get_db
from .models import User

async def get_current_user(db: Session = Depends(get_db)) -> User:
    # placeholder lamang
    user = db.query(User).first()
    if user is None:
        test_user = User(
            email="test@example.com",
            username="testuser",
            hashed_password="fake_hashed_password"
        )
        db.add(test_user)
        db.commit()
        db.refresh(test_user)
        return test_user
    return user
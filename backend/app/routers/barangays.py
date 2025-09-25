from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from .. import models, schemas
from ..db import get_db
from ..routers.auth import get_current_user

router = APIRouter(prefix="/barangays", tags=["barangays"])

@router.post("/", response_model=schemas.BarangayRead)
def create_barangay(
    barangay: schemas.BarangayCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    if current_user.role != "superadmin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only superadmin can create barangays"
        )
    new_barangay = models.Barangay(name=barangay.name)
    db.add(new_barangay)
    db.commit()
    db.refresh(new_barangay)
    return new_barangay

@router.get("/", response_model=List[schemas.BarangayRead])
def get_barangays(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    if current_user.role == "superadmin":
        return db.query(models.Barangay).all()
    elif current_user.role == "admin":
        if not current_user.barangay_id:
            return []
        barangay = db.query(models.Barangay).filter(models.Barangay.id == current_user.barangay_id).first()
        return [barangay] if barangay else []
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Invalid role")

@router.put("/{barangay_id}", response_model=schemas.BarangayRead)
def update_barangay(
    barangay_id: int,
    updated_barangay: schemas.BarangayCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    if current_user.role != "superadmin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only superadmin can update barangays"
        )
    barangay = db.query(models.Barangay).filter(models.Barangay.id == barangay_id).first()
    if not barangay:
        raise HTTPException(status_code=404, detail="Barangay not found")
    
    barangay.name = updated_barangay.name
    db.commit()
    db.refresh(barangay)
    return barangay

@router.delete("/{barangay_id}")
def delete_barangay(
    barangay_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    if current_user.role != "superadmin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only superadmin can delete barangays"
        )
    barangay = db.query(models.Barangay).filter(models.Barangay.id == barangay_id).first()
    if not barangay:
        raise HTTPException(status_code=404, detail="Barangay not found")
    
    db.delete(barangay)
    db.commit()
    return {"detail": "Barangay deleted successfully"}

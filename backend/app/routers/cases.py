from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from .. import models, schemas
from ..db import get_db
from ..routers.auth import get_current_user

router = APIRouter(prefix="/cases", tags=["cases"])

@router.post("/", response_model=schemas.CaseRead)
def create_case(
    case: schemas.CaseCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    new_case = models.Case(
        title=case.title,
        description=case.description,
        reporter_id=current_user.id
    )
    db.add(new_case)
    db.commit()
    db.refresh(new_case)
    return new_case

@router.get("/", response_model=List[schemas.CaseRead])
def get_cases(db: Session = Depends(get_db)):
    return db.query(models.Case).all()

@router.get("/{case_id}", response_model=schemas.CaseRead)
def get_case(case_id: int, db: Session = Depends(get_db)):
    case = db.query(models.Case).filter(models.Case.id == case_id).first()
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    return case

@router.put("/{case_id}", response_model=schemas.CaseRead)
def update_case(case_id: int, updated_case: schemas.CaseUpdate, db: Session = Depends(get_db)):
    case = db.query(models.Case).filter(models.Case.id == case_id).first()
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")

    for key, value in updated_case.dict(exclude_unset=True).items():
        setattr(case, key, value)

    db.commit()
    db.refresh(case)
    return case

@router.delete("/{case_id}")
def delete_case(case_id: int, db: Session = Depends(get_db)):
    case = db.query(models.Case).filter(models.Case.id == case_id).first()
    if not case:
        raise HTTPException(status_code=404, detail="Case not found")
    db.delete(case)
    db.commit()
    return {"detail": "Case deleted successfully"}

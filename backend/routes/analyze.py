from fastapi import APIRouter, UploadFile, File
from services.ai import analyze_image

router = APIRouter()

@router.post("/analyze")
async def analyze(file: UploadFile = File(...)):
    content = await file.read()

    result = analyze_image(content)

    return result
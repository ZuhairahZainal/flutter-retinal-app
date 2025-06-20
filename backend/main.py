import io
import torch
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from torchvision import transforms
from PIL import Image
from model.model_def import RetinaMultiTaskModel
from utils.tortuosity import compute_tortuosity
import os

app = FastAPI()

# Load model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = RetinaMultiTaskModel()
model.load_state_dict(torch.load("model/retina_model_sort.pth", map_location=device))
model.to(device)
model.eval()

# Image transform
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
])

@app.post("/analyze-file")
async def analyze_file(file: UploadFile = File(...)):
    try:
        contents = await file.read()

        # 1. Tortuosity calculation
        avg_tort, max_tort, num_vessels = compute_tortuosity(contents)

        # 2. Preprocess for model
        image = Image.open(io.BytesIO(contents)).convert("RGB")
        image_tensor = transform(image).unsqueeze(0).to(device)

        # 3. Predict with model
        with torch.no_grad():
            grade_logits, edema_logits = model(image_tensor)
            grade_pred = torch.argmax(grade_logits, dim=1).item()
            edema_pred = torch.argmax(edema_logits, dim=1).item()

        return JSONResponse(content={
            "retinopathy_grade": grade_pred,
            "edema_risk": edema_pred,
            "average_tortuosity": avg_tort,
            "max_tortuosity": max_tort,
            "num_vessels": num_vessels,
        })

    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})
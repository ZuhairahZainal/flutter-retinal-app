# main.py
import io
import torch
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from torchvision import transforms
from PIL import Image
from model.model_def import RetinaMultiTaskModel
from utils.tortuosity import compute_tortuosity
import subprocess
import os
# main.py (add at the top)
#from model.glaucoma_model_def import GlaucomaModel


app = FastAPI()

# Load retinopathy model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = RetinaMultiTaskModel()
model.load_state_dict(torch.load("model/model.pth", map_location=device))
model.to(device)
model.eval()


# Image preprocessing
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
])

@app.get("/")
def read_root():
    return {"message":"Hello world"}

@app.post("/predict_amd")
async def predict_amd(file: UploadFile = File(...)):
    try:
        # Ensure folder exists
        os.makedirs("deepseenet_test_images", exist_ok=True)

        # Save uploaded image
        test_image_path = f"deepseenet_test_images/{file.filename}"
        with open(test_image_path, "wb") as f:
            f.write(await file.read())

        # Update the CSV file dynamically with the new filename
        test_csv_path = "DeepSeeNet/examples/test_labels_single.csv"
        with open(test_csv_path, "w") as f:
            f.write("image\n")
            f.write(f"{file.filename}\n")

        # Run DeepSeeNet prediction script
        result = subprocess.run([
            "python", "DeepSeeNet/examples/predict_simplified_score.py",
            "--test_dir", "deepseenet_test_images",
            "--test_csv", test_csv_path,
            "--model_dir", "DeepSeeNet/models"
        ], capture_output=True, text=True)

        if result.returncode != 0:
            return JSONResponse(status_code=500, content={"error": result.stderr})

        # Parse results from stdout
        features = {}
        for line in result.stdout.strip().split("\n"):
            if ":" in line:
                key, value = line.split(":", 1)
                features[key.strip()] = value.strip()

        return {"AMD_Features": features}

    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

@app.post("/analyze")
async def analyze(file: UploadFile = File(...)):
    contents = await file.read()

    # --- Calculate tortuosity ---
    (avg_tortuosity, max_tort, num_vessels)  = compute_tortuosity(contents)

    # --- image processing ---
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    image_tensor = transform(image).unsqueeze(0).to(device)

    # --- retina model prediction ---
    with torch.no_grad():
        grade_logits, edema_logits = model(image_tensor)
        grade_pred = torch.argmax(grade_logits, dim=1).item()
        edema_pred = torch.argmax(edema_logits, dim=1).item()


    return JSONResponse(content={
        "retinopathy_grade": grade_pred,
        "edema_risk": edema_pred,
        "avg_vessel_tortuosity": avg_tortuosity,
        "max_vessel_toruosity": max_tort,
        "number_vessels_analysed": num_vessels,
    })

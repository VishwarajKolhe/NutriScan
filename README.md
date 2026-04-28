# NutriScan

AI-powered food label analyzer. Upload a photo of any packaged food product and instantly get a health score, ingredient breakdown, marketing claim fact-checks, and healthier alternatives — powered by Google Gemini 2.5 Flash.

**Live API:** https://nutriscanproject-1085535174080.europe-west1.run.app  
**API Docs:** https://nutriscanproject-1085535174080.europe-west1.run.app/docs

---

## Features

- **Health Score** — 0–100 rating based on visible ingredient quality
- **Ingredient Analysis** — every ingredient rated `good` / `bad` / `neutral` with a plain-language reason
- **Claims Fact-Check** — detects misleading labels like "natural", "low fat", "healthy"
- **Healthier Alternatives** — AI-suggested better products
- **Cross-Platform** — Android, iOS, Web, Windows, macOS, Linux

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter 3, Dart 3 |
| Backend | Python 3.11, FastAPI, Uvicorn |
| AI | Google Gemini 2.5 Flash |
| Hosting | Google Cloud Run (europe-west1) |
| CI/CD | Google Cloud Build |

---

## Project Structure

```
NutriScan/
├── backend/
│   ├── main.py                   # FastAPI app + CORS
│   ├── routes/analyze.py         # POST /analyze
│   ├── services/ai.py            # Gemini image analysis
│   ├── config/settings.py        # Env config
│   ├── Dockerfile
│   ├── cloudbuild.yaml
│   └── requirements.txt
└── frontend/nutriscan/
    └── lib/
        ├── main.dart
        ├── screens/
        │   ├── home_screen.dart   # Image upload UI
        │   └── result_screen.dart # Analysis results
        ├── services/api_service.dart
        └── widgets/image_card.dart
```

---

## API

### `GET /`
```json
{ "status": "running" }
```

### `POST /analyze`

**Request:** `multipart/form-data`, field name `file` (image)

**Response:**
```json
{
  "health_score": 62,
  "summary": "Contains mostly natural grains but uses palm oil and artificial preservatives.",
  "ingredients": [
    { "name": "Whole Wheat", "status": "good", "reason": "High fibre, natural grain" },
    { "name": "Palm Oil",    "status": "bad",  "reason": "High in saturated fat" }
  ],
  "claims_analysis": [
    { "claim": "natural", "truth": "Contains artificial preservatives", "verdict": "misleading" }
  ],
  "alternatives": ["Brand X Multigrain", "Brand Y Oats"]
}
```

---

## Local Setup

### Backend

```bash
cd backend
pip install -r requirements.txt
```

Create `backend/.env`:
```
GOOGLE_API_KEY=your_google_api_key_here
```

```bash
uvicorn main:app --reload --port 8000
```

### Frontend

```bash
cd frontend/nutriscan
flutter pub get
flutter run
```

---

## Deployment

The backend deploys automatically to Cloud Run on every push to `main` via Cloud Build (`backend/cloudbuild.yaml`).

**Required:** Set `GOOGLE_API_KEY` as an environment variable in the Cloud Run service:  
Cloud Run → Edit & Deploy New Revision → Variables & Secrets → Add Variable.

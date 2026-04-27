from google import genai
from config.settings import GOOGLE_API_KEY
import json
from PIL import Image
import io

client = genai.Client(api_key=GOOGLE_API_KEY)


def analyze_image(image_bytes: bytes):
    prompt = """
You are a STRICT food label analyzer.

Analyze ONLY what is visible in the image.

Rules:
- Do NOT guess ingredients
- Do NOT assume product type
- Only list clearly visible ingredients
- If unsure → skip

Also:
- Penalize processed oils, excess salt, artificial additives
- Reward natural ingredients

Also detect misleading claims if visible:
- "healthy"
- "natural"
- "low fat"

Add field:
"claims_analysis": [
  {
    "claim": "",
    "truth": "",
    "verdict": "true/misleading"
  }
]

Return JSON:
{
  "health_score": number,
  "ingredients": [
    {
      "name": "",
      "status": "good/bad/neutral",
      "reason": ""
    }
  ],
  "summary": "",
  "alternatives": []
}
"""

    try:
        image = Image.open(io.BytesIO(image_bytes))

        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=[prompt, image], 
        )

        raw = response.text.strip()
        raw = raw.replace("```json", "").replace("```", "").strip()

        print("RAW GEMINI RESPONSE:", raw)

        return json.loads(raw)

    except Exception as e:
        print("Gemini Error:", e)

        return {
            "health_score": 50,
            "ingredients": [],
            "summary": "Unable to analyze image clearly",
            "alternatives": []
        }
"""Publica reglas Firestore que permiten lectura pública de products/prices/metadata."""
import google.auth.transport.requests
import google.oauth2.service_account
import requests

SA_PATH = "service_account.json"
PROJECT_ID = "cestaiq"

RULES = """service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{docId} {
      allow read: if true;
    }
    match /prices/{docId} {
      allow read: if true;
    }
    match /metadata/{docId} {
      allow read: if true;
    }
  }
}"""

creds = google.oauth2.service_account.Credentials.from_service_account_file(
    SA_PATH,
    scopes=["https://www.googleapis.com/auth/cloud-platform"],
)
creds.refresh(google.auth.transport.requests.Request())
headers = {"Authorization": f"Bearer {creds.token}", "Content-Type": "application/json"}

BASE = f"https://firebaserules.googleapis.com/v1/projects/{PROJECT_ID}"

# 1. Crear nuevo ruleset
r = requests.post(
    f"{BASE}/rulesets",
    headers=headers,
    json={"source": {"files": [{"content": RULES, "name": "firestore.rules"}]}},
)
r.raise_for_status()
ruleset_name = r.json()["name"]
print(f"Ruleset creado: {ruleset_name}")

# 2. Publicar el release (PATCH con body correcto)
r2 = requests.patch(
    f"{BASE}/releases/cloud.firestore",
    headers=headers,
    json={
        "name": f"projects/{PROJECT_ID}/releases/cloud.firestore",
        "ruleset_name": ruleset_name,
    },
)
print(f"Release: {r2.status_code} {r2.text[:300]}")

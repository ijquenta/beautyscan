import os
import requests
import json

# Read .env file
env_vars = {}
with open('.env') as f:
    for line in f:
        if line.strip() and not line.startswith('#'):
            key, val = line.strip().split('=', 1)
            env_vars[key] = val.strip("'\"")

api_key = env_vars.get('API_KEY')
url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"
response = requests.get(url)
models = [m['name'] for m in response.json().get('models', []) if 'generateContent' in m.get('supportedGenerationMethods', [])]
print(models)

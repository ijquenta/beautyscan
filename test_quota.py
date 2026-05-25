import os
import requests
import json
import base64

# Read .env file
env_vars = {}
with open('.env') as f:
    for line in f:
        if line.strip() and not line.startswith('#'):
            key, val = line.strip().split('=', 1)
            env_vars[key] = val.strip("'\"")

api_key = env_vars.get('API_KEY')

models = ['gemini-3.1-flash-image-preview', 'gemini-3-pro-image-preview', 'nano-banana-pro-preview']
for model in models:
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    payload = {
        'contents': [
            {
                'role': 'user',
                'parts': [
                    {'text': 'Create a simple image'}
                ]
            }
        ],
        'generationConfig': {
            'responseModalities': ['IMAGE']
        }
    }
    resp = requests.post(url, json=payload)
    print(f"Model: {model}, Status: {resp.status_code}")
    if resp.status_code != 200:
        print(f"Error: {resp.json()}")

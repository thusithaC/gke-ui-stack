from fastapi import FastAPI
import random

app = FastAPI()

# Hardcoded list of names
names = ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"]


@app.get("/health")
async def health_check():
    return {"status": "healthy"}


@app.get("/api/get-name")
async def get_name():
    name = random.choice(names)
    return {"name": name}

import streamlit as st
import requests
import os

BACKEND_URL = os.getenv("BACKEND_URL", "http://localhost:8000")

st.title("Demo Streamlit with Backend Connection")

response = requests.get(f"{BACKEND_URL}/api/get-name")
if response.status_code == 200:
    name = response.json().get("name", "World")
    st.write(f"Hello there {name}")
else:
    st.write("Failed to fetch name from backend")

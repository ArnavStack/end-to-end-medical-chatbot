FROM python:3.10-slim-buster

WORKDIR /app

# copy only requirements first (faster caching)
COPY requirements.txt .

# install system deps
RUN apt-get update && apt-get install -y build-essential gcc

# upgrade pip
RUN pip install --upgrade pip

# 🔴 IMPORTANT: install lightweight CPU PyTorch first
RUN pip install --no-cache-dir torch==2.1.0 --index-url https://download.pytorch.org/whl/cpu

# install remaining libraries
RUN pip install --no-cache-dir -r requirements.txt

# now copy project files
COPY . .

# Railway uses dynamic PORT
CMD gunicorn app:app --bind 0.0.0.0:$PORT
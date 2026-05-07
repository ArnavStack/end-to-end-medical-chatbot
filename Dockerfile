FROM python:3.10-slim-buster

WORKDIR /app

# install system libs required for numpy / torch / transformers
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    git \
    curl \
    libgl1 \
    libglib2.0-0

COPY requirements.txt .

RUN pip install --upgrade pip

# install torch CPU first (important)
RUN pip install torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2

# install remaining python deps
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD gunicorn app:app --bind 0.0.0.0:$PORT
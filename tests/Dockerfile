# Image for building/serving the docs locally via make (see Makefile in the repo root).
# Build context is the repo root: docker build -f tests/Dockerfile .
FROM python:3-slim
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
WORKDIR /docs
EXPOSE 8000

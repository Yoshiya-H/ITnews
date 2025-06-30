FROM python:3.12-slim

WORKDIR /app

COPY *.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
RUN apt-get update && apt-get install -y curl iproute2
CMD [ "python", "app.py" ]
FROM python:3.12-slim

WORKDIR /app

COPY *.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
RUN netstat -tlnp | grep :5000
CMD [ "python", "app.py" ]
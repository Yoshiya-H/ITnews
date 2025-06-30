FROM python:3.12-slim-bullseye

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY rss_util.py .

EXPOSE 5000
CMD [ "gunicorn", "-b", "0.0.0.0:5000", "app:app" ]

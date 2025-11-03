FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends cron \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
COPY cron/cleanup-cron /etc/cron.d/cleanup-cron
COPY cron/entrypoint.sh /entrypoint.sh

RUN chmod 0644 /etc/cron.d/cleanup-cron \
    && crontab /etc/cron.d/cleanup-cron \
    && chmod +x /entrypoint.sh \
    && touch /var/log/cron.log

CMD ["/entrypoint.sh"]

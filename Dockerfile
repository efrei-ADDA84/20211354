FROM python:3.7-alpine3.17

ENV API_KEY=$API_KEY
ENV LAT=$LAT
ENV LONGITUDE=$LONG

WORKDIR /app

COPY requirement.txt /app

RUN apk update && apk upgrade && pip install --requirement --no-cache-dir requirement.txt

COPY meteo.py /app

CMD [ "python", "meteo.py" ]

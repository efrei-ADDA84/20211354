FROM python:3.7-alpine3.17

ENV API_KEY=$API_KEY

WORKDIR /app

COPY requirement.txt /app

RUN mkdir /templates

COPY templates /app/templates

RUN apk update && apk upgrade && pip install --no-cache-dir --requirement requirement.txt

COPY apimeteo.py /app

EXPOSE 5000

CMD [ "python", "apimeteo.py"]

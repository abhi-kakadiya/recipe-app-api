FROM python:3.9-alpine3.13
LABEL maintainer="abhikakadiya"

ENV PYTHONUNBUFFERED 1
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# when we build & run it will override the DEV arg to true(specified in docker-compose.yml)
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then  /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp  && \
    # Add a new user other than Root user in Docker image, so that if app is being attcaked by attacker then we do not have to compromise other things 
    adduser \ 
    --disabled-password \ 
    --no-create-home \
    django-user  

ENV PATH="/py/bin:$PATH"

USER django-user
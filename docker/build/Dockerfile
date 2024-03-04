FROM ruby:3.2.2-bullseye

## Prepare
RUN mkdir /app
WORKDIR /app

## Dependency
RUN apt update && apt install postgresql-client -y

## Config
RUN useradd -m dev
RUN usermod -a -G root dev

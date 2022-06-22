FROM ruby:3

RUN apt-get update && apt-get install \
    nodejs \
    curl \
    sqlite3 \
    yarn -y

WORKDIR /app

RUN gem install bundler

RUN gem install rails
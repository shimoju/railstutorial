FROM ruby:2.3.4

ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -qq curl \
  && curl -fsSL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -qq --no-install-recommends \
    build-essential \
    nodejs \
    libpq-dev \
    postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG BUNDLE_JOBS=2
COPY Gemfile Gemfile.lock ./
RUN bundle install

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

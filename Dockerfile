# Build compilation image
FROM ruby:2.7.2-alpine3.13

# Set bundler version
ENV BUNDLER_VERSION=2.2.6

ARG RAILS_ENV=production
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=${RAILS_ENV} \
    RACK_ENV=${RAILS_ENV} \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    GOVUK_APP_DOMAIN=www.gov.uk \
    GOVUK_WEBSITE_ROOT=https://www.gov.uk \
    SECRET_KEY_BASE=TestKey \
    IGNORE_SECRETS_FOR_BUILD=1

# Add the timezone as it's not configured by default in Alpine
RUN apk add --update --no-cache tzdata && \
  cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
  echo "Europe/London" > /etc/timezone

# build-base: complication tools for bundle
# git: version manager
# nodejs: JavaScript runtime built on Chrome's V8 JavaScript engine
# yarn: node package manager
# postgresql-dev: postgres driver and libraries
RUN apk --no-cache add --update \
  build-base \
  git \
  nodejs \
  npm \
  yarn \
  postgresql-dev \
  shared-mime-info

# The application runs from /app
WORKDIR /app

# Install bundler and gems defined in Gemfile
COPY .ruby-version Gemfile Gemfile.lock ./
RUN gem update --system \
    && gem install bundler:${BUNDLER_VERSION} --no-document \
    && bundle config set --local without 'development test' \
    && bundle install --no-binstubs  \
    && gem cleanup

COPY package.json yarn.lock ./
RUN yarn install

COPY . /app/

RUN bundle exec rake assets:precompile

# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.0
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Base runtime packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# -----------------------
# Build stage
# -----------------------
FROM base AS build

# Build dependencies + Node for JS assets
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libpq-dev pkg-config nodejs npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy Ruby gems and install
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy JS dependencies and install
COPY package.json package-lock.json ./
RUN npm install

# Copy Rails app
COPY . .

# Precompile bootsnap
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets (Tailwind + Flowbite works now)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# -----------------------
# Final stage
# -----------------------
FROM base

# Copy built artifacts
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run as non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]

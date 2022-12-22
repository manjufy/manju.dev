# STEP 1 - Docker image stage for building the release
ARG MIX_ENV="prod"
FROM hexpm/elixir:1.14.2-erlang-25.1-alpine-3.17.0  AS build

# Install build dependencies
RUN apk add --no-cache build-base git python3 curl

# Sets work directory
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}}"

COPY mix.exs mix.lock ./

RUN mix deps.get --only $MIX_ENV

# Copy compile configuration files
RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/

# Compile dependencies
RUN mix deps.compile

# Copy assets
COPY priv priv
COPY assets assets

# Compile assets
RUN mix assets.deploy

# Compile project
COPY lib lib
RUN mix compile

# Copy runtime configuration file
COPY config/runtime.exs config/

# Assemble release
RUN mix release

# STEP 2 - Docker image stage for running the release


# setup up variables
# install deps and compile deps
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock
RUN mix do deps.get --only $MIX_ENV, deps.compile
RUN mix compile

################################################################################
# STEP 2 - RELEASE BUILDER
FROM hexpm/elixir:1.14.2-erlang-25.1-alpine-3.17.0  AS release-builder

ENV MIX_ENV=prod
RUN mkdir /app
WORKDIR /app

# setup up variables
ARG APP_NAME
ARG APP_VSN

# need to install deps again to run mix phx.digest
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    git \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

# copy elixir deps
COPY --from=deps-getter /app /app

# copy config, priv and release directories
COPY config /app/config
COPY priv /app/priv
COPY rel /app/rel

RUN mix phx.digest

COPY lib /app/lib

# create release
RUN mkdir -p /opt/built &&\
    mix release ${APP_NAME} &&\
    cp -r _build/prod/rel/${APP_NAME} /opt/built

################################################################################

## STEP 3 - FINAL
FROM alpine:3.11.3

ENV MIX_ENV=prod

RUN apk update && \
    apk add --no-cache \
    bash \
    openssl-dev

COPY --from=release-builder /opt/built /app
WORKDIR /app
CMD ["/app/phxtmpl/bin/phxtmpl", "start"]
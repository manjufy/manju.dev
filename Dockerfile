################################################################################
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

################################################################################
# STEP 2 - Docker image stage for running the release
FROM alpine:3.17.0 AS app

ARG MIX_ENV

# Install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

ENV USER="manju"

WORKDIR "/home/${USER}/app"

# Create unprivileged user to run the release
RUN \
addgroup -g 1000 -S "${USER}" \
&& adduser \
-s /bin/sh \
-u 1000 \
-G "${USER}" \
-h "/home/${USER}" \
-D "${USER}" \
&& su "${USER}"

# run as user
USER "${USER}"

# copy release executable
COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/portal ./

ENTRYPOINT ["bin/portal"]

CMD ["start"]
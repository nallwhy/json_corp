# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian
# instead of Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20220801-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.14.0-erlang-25.0.4-debian-bullseye-20220801-slim
#
ARG ELIXIR_VERSION=1.14.0
ARG OTP_VERSION=25.0.4
ARG DEBIAN_VERSION=bullseye-20220801-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git npm \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"
ENV APP_NAME=json_corp

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/${APP_NAME}/mix.exs ./apps/${APP_NAME}/mix.exs
COPY apps/${APP_NAME}_web/mix.exs ./apps/${APP_NAME}_web/mix.exs
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
# COPY config/config.exs config/${MIX_ENV}.exs config/
COPY config ./config
RUN mix deps.compile

COPY apps/${APP_NAME}/priv ./apps/${APP_NAME}/priv
COPY apps/${APP_NAME}_web/priv ./apps/${APP_NAME}_web/priv

COPY apps/${APP_NAME}/lib ./apps/${APP_NAME}/lib
COPY apps/${APP_NAME}_web/lib ./apps/${APP_NAME}_web/lib

COPY apps/${APP_NAME}_web/assets ./apps/${APP_NAME}_web/assets

# release setup (ex. compile assets)
RUN mix release.setup

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"
ENV RELEASE_NAME=json_corp_app

# Fly.io https://fly.io/docs/elixir/getting-started/#important-ipv6-settings
# ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/${RELEASE_NAME} ./

USER nobody

CMD ["/app/bin/server"]

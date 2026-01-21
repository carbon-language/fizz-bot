FROM debian:stable-slim
RUN apt-get update
RUN apt-get install -y ca-certificates

LABEL org.opencontainers.image.authors="danakj@orodu.net"

COPY target/release/fizz /usr/bin/fizz
ENV FIZZ_CONFIG_DIR=/config
# ENV DISCORD_TOKEN="provide this when running the docker image"

ENTRYPOINT ["fizz"]


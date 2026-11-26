ARG ERL_VERSION=29.1.3.0-alpine
ARG GLEAM_VERSION=1.19.2-erlang-alpine

FROM ghcr.io/gleam-lang/gleam:v${GLEAM_VERSION} AS gleam
FROM erlang:${ERL_VERSION} AS build
COPY --from=gleam /bin/gleam /bin/gleam
COPY . /app/
RUN cd /app && gleam export erlang-shipment

FROM erlang:${ERL_VERSION}
RUN \
  addgroup --system helloer && \
  adduser --system helloer -g helloer
COPY --from=build /app/build/erlang-shipment /app
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]

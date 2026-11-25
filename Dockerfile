FROM erlang:29.0.0.0-alpine AS build
COPY --from=ghcr.io/gleam-lang/gleam:v1.17.0-erlang-alpine /bin/gleam /bin/gleam
COPY . /app/
RUN cd /app && gleam export erlang-shipment

FROM erlang:29.0.0.0-alpine
RUN \
  addgroup --system helloer && \
  adduser --system helloer -g helloer
COPY --from=build /app/build/erlang-shipment /app
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]

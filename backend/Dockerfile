ARG SERVERPOD_PATH=tracker_backend/tracker_backend_server

FROM dart:3.5.0 AS build

ARG SERVERPOD_PATH
WORKDIR /app

# Copy the Serverpod server package into the build context.
COPY ${SERVERPOD_PATH}/ .

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

FROM alpine:3.19

ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies from the Dart image.
COPY --from=build /runtime/ /

# Copy the compiled server and configuration assets.
COPY --from=build /app/bin/server server
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

CMD ["sh", "-c", "./server --mode=${runmode} --server-id=${serverid} --logging=${logging} --role=${role}"]

FROM debian:bookworm-slim AS build

ARG DEBIAN_FRONTEND=noninteractive
ARG FLUTTER_VERSION=3.24.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    python3 \
    unzip \
    xz-utils \
  && update-ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o /tmp/flutter.tar.xz \
  && tar -xJf /tmp/flutter.tar.xz -C /opt \
  && rm /tmp/flutter.tar.xz

RUN git config --global --add safe.directory ${FLUTTER_HOME}
RUN flutter config --enable-web

WORKDIR /workspace

# Bring the path dependency into the container before running pub get.
COPY backend/tracker_backend/tracker_backend_client backend/tracker_backend/tracker_backend_client

WORKDIR /workspace/app
COPY app/pubspec.yaml app/pubspec.lock ./
RUN flutter pub get

COPY app/ .
RUN flutter build web --release

# Drop cached downloads to shrink the layer size.
RUN rm -rf ${FLUTTER_HOME}/bin/cache/downloads

FROM nginx:1.25-alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /workspace/app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

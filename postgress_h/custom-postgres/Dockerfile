FROM bitnami/postgresql-repmgr:15

USER root

# Instala todas las dependencias necesarias, incluyendo zlib1g-dev
RUN install_packages \
    gcc \
    git \
    meson \
    ninja-build \
    libxml2-dev \
    libssl-dev \
    libpq-dev \
    liblz4-dev \
    libbz2-dev \
    libzstd-dev \
    libyaml-dev \
    pkg-config \
    zlib1g-dev \
    ca-certificates \
    curl \
    make

# Clonar y compilar pgBackRest
RUN git clone https://github.com/pgbackrest/pgbackrest.git /tmp/pgbackrest && \
    cd /tmp/pgbackrest && \
    meson setup build && \
    ninja -C build && \
    ninja -C build install && \
    rm -rf /tmp/pgbackrest

USER 1001

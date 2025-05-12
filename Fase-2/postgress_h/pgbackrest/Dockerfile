FROM ubuntu:25.04

# Instalar pgBackRest y dependencias
RUN apt-get update && apt-get install -y \
    pgbackrest \
    postgresql-client \
    libdbd-pg-perl \
    libjson-perl \
    libxml-libxml-perl \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios necesarios
RUN mkdir -p /var/lib/pgbackrest \
    && mkdir -p /var/log/pgbackrest \
    && mkdir -p /etc/pgbackrest \
    && chmod 750 /var/lib/pgbackrest \
    && chmod 750 /var/log/pgbackrest \
    && chmod 750 /etc/pgbackrest

# Crear directorio para scripts
RUN mkdir -p /scripts

WORKDIR /scripts

# Establecer permisos para scripts
CMD ["tail", "-f", "/dev/null"]
FROM postgres:9.5.2

RUN apt-get update -y

RUN apt-get install -y postgresql-server-dev-9.5 postgresql-9.5 \
                        libedit-dev libselinux1-dev libxslt-dev  \
                        libpam0g-dev git flex make

RUN mkdir /citus
RUN mkdir -p /etc/citus

ADD . /citus

RUN chown postgres:postgres -R /citus
RUN chown postgres:postgres -R /etc/citus

WORKDIR /citus

RUN ./configure && \
   make && \
   make install

WORKDIR /

RUN echo "shared_preload_libraries='citus'" >> /usr/share/postgresql/postgresql.conf.sample

COPY 000-symlink-workerlist.sh 001-create-citus-extension.sql /docker-entrypoint-initdb.d/

VOLUME /etc/citus

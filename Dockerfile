# OpenBot (nightly-labs) para a Vertra Cloud. Teste, NAO use em producao sem ler a licenca (PolyForm Noncommercial).
# Copia o release da imagem oficial e refaz o resto do jeito que a Vertra exige:
# usuario 1000:1000, so /app persiste, resto somente leitura. Sem VOLUME e sem EXPOSE (app sem porta publica).
ARG BASE=ubuntu:24.04@sha256:a853f94d226358a79c740cfc7bce0c289748f3fe3488d921d038ccd752c61b60
FROM ghcr.io/nightly-labs/openbot:latest AS src

FROM ${BASE}
ARG DEBIAN_FRONTEND=noninteractive
COPY --from=src /opt/OpenBot /opt/OpenBot
RUN apt-get update \
  && sed -e '/^#/d' -e '/^$/d' -e '/^apparmor$/d' /opt/OpenBot/app/resources/hosting/packages.txt \
    | xargs apt-get install --yes --no-install-recommends \
      git less openssh-client procps ripgrep tini unzip xz-utils \
  && rm -rf /var/lib/apt/lists/*
# Usuario 1000 com home em /app/data (o unico disco persistente). /data vira atalho para o mesmo lugar.
RUN userdel --remove ubuntu \
  && useradd --uid 1000 --user-group --home-dir /app/data --shell /bin/bash openbot \
  && ln -s /app/data /data \
  && ln -sf /opt/OpenBot/app/resources/hosting/openbot /usr/local/bin/openbot
COPY start-vertra.sh /usr/local/bin/start-vertra.sh
RUN chmod 0755 /usr/local/bin/start-vertra.sh
ENV LANG=C.UTF-8 XDG_RUNTIME_DIR=/run/openbot
ENV PATH=${PATH}:/app/data/.local/bin
USER 1000:1000
WORKDIR /app
STOPSIGNAL SIGTERM
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/start-vertra.sh"]

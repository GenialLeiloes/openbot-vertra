# OpenBot (nightly-labs) para a Vertra Cloud. Teste, NAO use em producao sem ler a licenca (PolyForm Noncommercial).
# Copia o rootfs da imagem oficial sobre Ubuntu (sem apt: o overlay da Vertra falha no liblzma).
# Usuario 1000:1000, so /app persiste. Sem VOLUME e sem EXPOSE (app sem porta publica).
ARG BASE=ubuntu:24.04@sha256:a853f94d226358a79c740cfc7bce0c289748f3fe3488d921d038ccd752c61b60
FROM ghcr.io/nightly-labs/openbot:latest AS src

FROM ${BASE}
COPY --from=src / /
COPY start-vertra.sh /usr/local/bin/start-vertra.sh
RUN chmod 0755 /usr/local/bin/start-vertra.sh \
  && mkdir -p /app/data \
  && rm -rf /data \
  && ln -s /app/data /data
ENV LANG=C.UTF-8 XDG_RUNTIME_DIR=/run/openbot
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data/.local/bin
USER 1000:1000
WORKDIR /app
STOPSIGNAL SIGTERM
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/start-vertra.sh"]

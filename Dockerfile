# OpenBot (nightly-labs) para a Vertra Cloud. Teste, NAO use em producao sem ler a licenca (PolyForm Noncommercial).
# Copia o rootfs da imagem oficial e descarta VOLUME/EXPOSE (nao herdados por COPY).
# Sem apt: o build da Vertra falha ao atualizar liblzma ("No such device" no overlay).
# Usuario 1000:1000, so /app persiste. Sem VOLUME e sem EXPOSE (app sem porta publica).
FROM ghcr.io/nightly-labs/openbot:latest AS src

FROM scratch
COPY --from=src / /
COPY start-vertra.sh /usr/local/bin/start-vertra.sh
RUN chmod 0755 /usr/local/bin/start-vertra.sh \
  && rm -rf /data \
  && ln -s /app/data /data
ENV LANG=C.UTF-8 XDG_RUNTIME_DIR=/run/openbot
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data/.local/bin
USER 1000:1000
WORKDIR /data
STOPSIGNAL SIGTERM
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/start-vertra.sh"]

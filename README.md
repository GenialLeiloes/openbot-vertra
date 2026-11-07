# openbot-vertra

Contexto de build da imagem Docker do OpenBot (nightly-labs) para a Vertra Cloud.

- `Dockerfile` na raiz, como a Vertra exige.
- Sem `--no-sandbox`.
- Sem porta pública (`EXPOSE`).
- Dados em `/app/data` (único disco persistente da Vertra).

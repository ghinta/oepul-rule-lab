FROM mcr.microsoft.com/devcontainers/python:1-3.12-bookworm

ARG OPA_VERSION=1.18.2

RUN set -eux; \
    architecture="$(dpkg --print-architecture)"; \
    case "$architecture" in \
      amd64) opa_arch="amd64" ;; \
      arm64) opa_arch="arm64" ;; \
      *) echo "Unsupported architecture: $architecture" >&2; exit 1 ;; \
    esac; \
    curl --fail --location --retry 3 \
      "https://openpolicyagent.org/downloads/v${OPA_VERSION}/opa_linux_${opa_arch}_static" \
      --output /usr/local/bin/opa; \
    chmod 0755 /usr/local/bin/opa; \
    opa version

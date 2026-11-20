FROM python:3.12.13-slim-bookworm
RUN useradd --create-home --uid 1000 --shell /bin/bash rulelab && mkdir -p /run/workspace && chown rulelab:rulelab /run/workspace
COPY vendor/ /opt/codex/
RUN chmod -R a+rX /opt/codex
ENV PATH="/opt/codex/bin:/opt/codex/codex-path:/usr/local/bin:/usr/bin:/bin"
USER rulelab
WORKDIR /run/workspace
ENTRYPOINT ["/opt/codex/bin/codex"]

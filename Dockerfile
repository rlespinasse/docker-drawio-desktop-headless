FROM debian:bullseye

WORKDIR "/opt/drawio-desktop"

ENV DRAWIO_VERSION "21.5.1"
RUN set -e; \
  apt-get update && apt-get install -y \
  xvfb \
  wget \
  libgbm1 \
  libasound2; \
  wget -q https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VERSION}/drawio-amd64-${DRAWIO_VERSION}.deb \
  && apt-get install -y /opt/drawio-desktop/drawio-amd64-${DRAWIO_VERSION}.deb \
  && rm -rf /opt/drawio-desktop/drawio-amd64-${DRAWIO_VERSION}.deb; \
  apt-get remove -y wget; \
  rm -rf /var/lib/apt/lists/*;

COPY scripts/* ./

ENV ELECTRON_DISABLE_SECURITY_WARNINGS "true"
ENV DRAWIO_DISABLE_UPDATE "true"
ENV DRAWIO_DESKTOP_COMMAND_TIMEOUT "10s"
ENV DRAWIO_DESKTOP_EXECUTABLE_PATH "/opt/drawio/drawio"
ENV DRAWIO_DESKTOP_RUNNER_COMMAND_LINE "/opt/drawio-desktop/runner.sh"
ENV XVFB_DISPLAY ":42"
ENV XVFB_OPTIONS ""
ENV ELECTRON_ENABLE_LOGGING "false"

ENTRYPOINT [ "/opt/drawio-desktop/entrypoint.sh" ]
CMD [ "--help" ]

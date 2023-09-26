FROM debian:bullseye
ARG TARGETARCH

WORKDIR "/opt/drawio-desktop"

ENV DRAWIO_VERSION "21.8.2"
RUN set -e; \
  echo "selected arch: ${TARGETARCH}"; \
  apt-get update && apt-get install -y \
  xvfb \
  wget \
  libgbm1 \
  libasound2 \
  # Fonts
  fonts-liberation fonts-arphic-ukai fonts-arphic-uming fonts-noto fonts-noto-cjk fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core \
  ; wget -q https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VERSION}/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb \
  && apt-get install -y /opt/drawio-desktop/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb \
  && rm -rf /opt/drawio-desktop/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb; \
  apt-get remove -y wget; \
  rm -rf /var/lib/apt/lists/*;

COPY src/* ./

ENV ELECTRON_DISABLE_SECURITY_WARNINGS "true"
ENV DRAWIO_DISABLE_UPDATE "true"
ENV DRAWIO_DESKTOP_COMMAND_TIMEOUT "10s"
ENV DRAWIO_DESKTOP_EXECUTABLE_PATH "/opt/drawio/drawio"
ENV DRAWIO_DESKTOP_SOURCE_FOLDER "/opt/drawio-desktop"
ENV DRAWIO_DESKTOP_RUNNER_COMMAND_LINE "/opt/drawio-desktop/runner.sh"
ENV XVFB_DISPLAY ":42"
ENV XVFB_OPTIONS ""
ENV ELECTRON_ENABLE_LOGGING "false"

ENTRYPOINT [ "/opt/drawio-desktop/entrypoint.sh" ]
CMD [ "--help" ]

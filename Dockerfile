#checkov:skip=CKV_DOCKER_2
#checkov:skip=CKV_DOCKER_3
FROM debian:bullseye
ARG TARGETARCH

WORKDIR "/opt/drawio-desktop"

# hadolint ignore=DL3008,DL3015
RUN <<EOF
set -e
echo "selected arch: ${TARGETARCH}"

# fix for libc issue
rm /var/lib/dpkg/info/libc-bin.*
apt-get clean

# Deps
apt-get update
apt-get install -y xvfb wget libgbm1 libasound2

# Drawio Desktop
DRAWIO_VERSION="27.0.9"
wget -q https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VERSION}/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb
apt-get install -y /opt/drawio-desktop/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb
rm -rf /opt/drawio-desktop/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb

# Additional Fonts
apt-get install -y fonts-liberation \
  fonts-arphic-ukai fonts-arphic-uming \
  fonts-noto fonts-noto-cjk \
  fonts-ipafont-mincho fonts-ipafont-gothic \
  fonts-unfonts-core

# Cleanup layer
apt-get remove -y wget
apt-get clean
rm -rf /var/lib/apt/lists/*

# Enable all users to write in the WORKDIR folder
chmod a+w .
EOF

COPY --chmod=755 src/* ./

ENV ELECTRON_DISABLE_SECURITY_WARNINGS "true"
ENV DRAWIO_DISABLE_UPDATE "true"
ENV DRAWIO_DESKTOP_COMMAND_TIMEOUT "10s"
ENV DRAWIO_DESKTOP_EXECUTABLE_PATH "/opt/drawio/drawio"
ENV DRAWIO_DESKTOP_SOURCE_FOLDER "/opt/drawio-desktop"
ENV DRAWIO_DESKTOP_RUNNER_COMMAND_LINE "/opt/drawio-desktop/runner.sh"
ENV XVFB_DISPLAY ":42"
ENV XVFB_OPTIONS "-nolisten unix"
ENV ELECTRON_ENABLE_LOGGING "false"
ENV SCRIPT_DEBUG_MODE "false"

ENTRYPOINT [ "/opt/drawio-desktop/entrypoint.sh" ]
CMD [ "--help" ]

FROM ghcr.io/pundiai/fx-core:8.5.1 AS fxcore-mainnet
FROM functionx/fx-core:dhobyghaut-v2.0.1 AS fxcore-testnet
FROM ghcr.io/functionx/fxcorevisor:6.0.0 AS fxcore-mainnet-visor
FROM ubuntu:20.04 AS fxcore-ubuntu

# Build arguments.
ARG FXHOME
ARG FXNET=testnet

# Environmental variables.
ENV HOME=/home/fxcore
ENV FXHOME=$HOME/.fxcore

# Install prerequisites.
RUN  apt-get update \
  && apt-get install --no-install-recommends -qqq musl=1.1.24-1 \
  && rm -rf /var/lib/apt/lists/*

# Copy fxcored binary.
COPY --from=fxcore-mainnet /usr/bin/fxcored /usr/bin/fxcored-mainnet
COPY --from=fxcore-mainnet-visor /usr/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=fxcore-testnet /usr/bin/fxcored /usr/bin/fxcored-testnet
RUN mv "/usr/bin/fxcored-$FXNET" /usr/bin/fxcored

# Setup the default user.
# hadolint ignore=DL3059
RUN useradd -rm -d "$HOME" -s /bin/bash -g root -G sudo -u 1000 fxcore
USER fxcore
WORKDIR "$HOME"

# Add configuration files.
ADD --chown=fxcore:root [\
  "https://raw.githubusercontent.com/FunctionX/fx-core/v4.2.1/public/${FXNET}/app.toml",\
  "https://raw.githubusercontent.com/FunctionX/fx-core/v4.2.1/public/${FXNET}/config.toml",\
  "https://raw.githubusercontent.com/FunctionX/fx-core/v4.2.1/public/${FXNET}/genesis.json",\
  "$FXHOME/config-$FXNET/"]

# Update app configuration.
RUN fxcored config update && fxcored version
#RUN fxcored config config.toml log_level warn

# Update Docker configuration.
ENTRYPOINT ["/usr/bin/fxcored"]
EXPOSE 1317/TCP 8545/TCP 8546/TCP 9090/TCP 26656/TCP 26657/TCP 26660/TCP
HEALTHCHECK CMD ["/usr/bin/bash", "-c", "</dev/tcp/127.0.0.1/26657"]
VOLUME "$FXHOME/config" "$FXHOME/cosmovisor" "$FXHOME/data"
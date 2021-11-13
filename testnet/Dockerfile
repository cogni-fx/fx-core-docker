FROM functionx/fx-core:testnet-1.0 AS fxcore
FROM ubuntu:20.04

# Build arguments.
ARG FXHOME
ARG NETNAME=testnet

# Environmental variables.
ENV FXHOME $HOME/.fxcore
ENV HOME /home/fxcore

# Copy fxcored binary.
COPY --from=fxcore /usr/bin/fxcored /usr/bin/fxcored

# Setup the default user.
RUN useradd -rm -d "$HOME" -s /bin/bash -g root -G sudo -u 1000 fxcore
USER fxcore
WORKDIR "$HOME"

# Add configuration files.
ADD --chown=fxcore:root [\
  "https://raw.githubusercontent.com/functionx/fx-core/$NETNAME/public/app.toml",\
  "https://raw.githubusercontent.com/functionx/fx-core/$NETNAME/public/config.toml",\
  "https://raw.githubusercontent.com/functionx/fx-core/$NETNAME/public/genesis.json",\
  "$FXHOME/config/"]

# Update app configuration.
RUN fxcored config config.toml log_level warn

# Update Docker configuration.
ENTRYPOINT ["/usr/bin/fxcored"]
EXPOSE 1317/TCP 9090/TCP 26656/TCP 26656/UDP 26657/TCP 26660/TCP
HEALTHCHECK CMD ["/usr/bin/bash", "-c", "</dev/tcp/127.0.0.1/26657"]
VOLUME "$HOME"

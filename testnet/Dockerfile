FROM functionx/fx-core:testnet AS fxcore
FROM ubuntu:20.04

# Build arguments.
ARG TMHOME

# Environmental variables.
ENV HOME /home/fxcore
ENV TMHOME /fxcore

# Copy fxcored binary.
COPY --from=fxcore /usr/bin/fxcored /usr/bin/fxcored

# Setup the default user.
RUN useradd -rm -d "$HOME" -s /bin/bash -g root -G sudo -u 1000 fxcore
USER fxcore
WORKDIR "$HOME"

# Add configuration files.
ADD --chown=fxcore:root [\
  "https://raw.githubusercontent.com/functionx/fx-core/testnet/public/app.toml",\
  "https://raw.githubusercontent.com/functionx/fx-core/testnet/public/config.toml",\
  "https://raw.githubusercontent.com/functionx/fx-core/testnet/public/genesis.json",\
  "$HOME/.fxcore/config/"]

# Update configuration.
RUN fxcored config config.toml log_level warn

ENTRYPOINT ["/usr/bin/fxcored"]
VOLUME "$HOME"

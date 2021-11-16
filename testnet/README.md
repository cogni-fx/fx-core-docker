# f(x) Testnet

## Volumes

Example how to create Docker volumes:

```shell
docker volume create --name=fxcore-testnet-config --opt type=none --opt o=bind --opt device=/var/opt/fxcore-testnet-config
docker volume create --name=fxcore-testnet-data  --opt type=none --opt o=bind --opt device=/var/opt/fxcore-testnet-data
docker volume ls
```

Ensure volume paths exists or create them:

```shell
mkdir -m 770 -pv /var/opt/fxcore-testnet-config /var/opt/fxcore-testnet-data
```

Note: Prefix with `sudo` for elevated privileges.

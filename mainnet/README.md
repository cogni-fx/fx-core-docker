# f(x) mainnet

## Volumes

Example how to create Docker volumes:

```shell
docker volume create --name=fxcore-mainnet-config --opt type=none --opt o=bind --opt device=/var/opt/fxcore-mainnet-config
docker volume create --name=fxcore-mainnet-data  --opt type=none --opt o=bind --opt device=/var/opt/fxcore-mainnet-data
docker volume ls
```

Ensure volume paths exists or create them:

```shell
mkdir -m 770 -pv /var/opt/fxcore-mainnet-config /var/opt/fxcore-mainnet-data
```

Note: Prefix with `sudo` for elevated privileges.

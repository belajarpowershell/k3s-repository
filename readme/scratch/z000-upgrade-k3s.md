# k3s upgrade steps

backup

```bash
sudo systemctl stop k3s
sudo cp -a /var/lib/rancher/k3s /var/lib/rancher/k3s-backup-$(date +%F)
sudo systemctl start k3s

```

## Upgrade to latest

```bash
curl -sfL https://get.k3s.io | sudo sh -s - \
  server \
  --write-kubeconfig-mode 644 \
  --tls-san k3s-master \
  --disable traefik
```

## Upgrade but pin a specific version (safer in prod)

```bash

curl -sfL https://get.k3s.io | \
INSTALL_K3S_VERSION=v1.29.3+k3s1 \
sudo sh -s - \
  server \
  --write-kubeconfig-mode 644 \
  --tls-san k3s-master \
  --disable traefik


```

# Install ingress-nginx

## Install via helm

```bash
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.10.0 -n ingress-nginx --create-namespace --set controller.extraArgs.enable-ssl-passthrough=true 

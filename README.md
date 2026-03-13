# HidroPuga

Despliegue profesional de HidroPuga con Dockerfile + Docker Compose en Dokploy.

## Archivos del repo
- Dockerfile
- docker-compose.yml
- shiny-server.conf

## Archivos de la app en el servidor
- /root/apps/hidropuga/app/app.R
- /root/apps/hidropuga/logs

## Variables esperadas en Dokploy
- APP_PORT
- TZ
- APP_DIR
- LOG_DIR

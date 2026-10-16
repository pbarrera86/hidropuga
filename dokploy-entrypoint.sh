#!/bin/sh
set -eu
# Runtime projection only: values always originate in the current Dokploy container.
install -d -o root -g shiny -m 0750 /run/hidropuga
Rscript --vanilla -e 'keys <- c("STRIPE_MODE","STRIPE_TEST_WEBHOOK_SECRET","STRIPE_TEST_PRICE_MONTHLY","STRIPE_TEST_PRICE_YEARLY","HP_MONTHLY_QUOTA","HP_YEARLY_QUOTA","HP_REFERRAL_PERCENT","DB_HOST","DB_PORT","DB_NAME","DB_USER","DB_PASS","ADMIN_USER","ADMIN_EMAIL","ADMIN_PASS","GMAIL_APP_PASSWORD","SMTP_HOST","SMTP_PORT","SMTP_USERNAME","SMTP_FROM","STRIPE_SECRET_KEY","STRIPE_PUBLISHABLE_KEY","STRIPE_WEBHOOK_SECRET","STRIPE_TEST_SECRET_KEY","STRIPE_TEST_PUBLISHABLE_KEY","STRIPE_PRICE_MONTHLY","STRIPE_PRICE_YEARLY","APP_URL","APP_PORT","TZ"); values<-Sys.getenv(keys,unset=""); required<-c("DB_HOST","DB_NAME","DB_USER","DB_PASS","ADMIN_EMAIL","GMAIL_APP_PASSWORD","APP_URL"); missing<-required[!nzchar(values[required])]; if(length(missing))stop(paste("Faltan variables de Dokploy:",paste(missing,collapse=", ")));saveRDS(values,"/run/hidropuga/config.rds")'
chown root:shiny /run/hidropuga/config.rds
chmod 0640 /run/hidropuga/config.rds
if [ -f /srv/shiny-server/private/worker.R ]; then
  runuser -u shiny -- Rscript --vanilla /srv/shiny-server/private/worker.R >> /var/log/shiny-server/hidropuga-worker.log 2>&1 &
fi
if [ -f /srv/shiny-server/private/webhook_worker.R ]; then
  runuser -u shiny -- Rscript --vanilla /srv/shiny-server/private/webhook_worker.R >> /var/log/shiny-server/hidropuga-webhook.log 2>&1 &
fi
exec "$@"

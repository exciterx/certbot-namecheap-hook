#!/bin/bash -e

# Variants to get public ip "curl http://ipgrab.io" or "curl ifconfig.me" or "curl checkip.amazonaws.com"
PublicIP="$(curl checkip.amazonaws.com)"

# Required environment variables
export API_USER=namecheap_user
export API_KEY=namecheap_api_key
export USERNAME=namecheap_user
export CLIENT_IP=${PublicIP}
export SLD=mydomain
export TLD=com
export DOMAINS=*.mydomain.com
export ACME_MODE=prod
export EMAIL=user@gmail.com

# if CLIENT_IP is not set, then local IP will be used
. ./utility.sh
check_python_version
get_client_ip
get_acme_server

# Default dirs are not using because of the permission restriction on Mac OS

# ----------------- certbot renew a wildcard cert --------------------
# certbot renew \
# --logs-dir /usr/local/var/log/letsencrypt \
# --work-dir /usr/local/var/letsencrypt \
# --config-dir /usr/local/etc/letsencrypt \
# --preferred-challenges=dns \
# --pre-hook ./authenticator.sh \
# --post-hook ./cleanup.sh \
# --server $ACME_SERVER
# ----------------------------------------------------------------------

# ---------- certbot certonly obtaining a new wildcard cert ------------
certbot certonly \
-v \
--manual \
--logs-dir /usr/local/var/log/letsencrypt \
--work-dir /usr/local/var/letsencrypt \
--config-dir /usr/local/etc/letsencrypt \
--preferred-challenges=dns \
--manual-auth-hook ./authenticator.sh \
--manual-cleanup-hook ./cleanup.sh \
-d $DOMAINS \
--email $EMAIL \
--no-eff-email \
--server $ACME_SERVER \
--agree-tos \
--manual-public-ip-logging-ok \
--force-renewal
# ----------------------------------------------------------------------

#!/bin/bash
set -e

if [ ! -f /etc/duoauthproxy/secrets ]; then
  echo "Running Duo SSO enrollment..."
  key=$(cat /run/secrets/duo_enrollment_key)
  /opt/duoauthproxy/bin/authproxy_update_sso_enrollment_code "$key" \
    && /opt/duoauthproxy/bin/authproxyctl restart
else
        echo "Skipping Enrollment as already enrolled."
fi

# Run cmd
exec /opt/duoauthproxy/bin/authproxy

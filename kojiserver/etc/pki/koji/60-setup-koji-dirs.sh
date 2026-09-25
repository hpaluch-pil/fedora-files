#!/bin/bash
set -xeuo pipefail
dnf install koji-hub koji-web mod_ssl python3-jinja2
# copy CA cert
cp koji_ca_cert.crt  /etc/kojiweb/kojihubca.crt
# add simple landing page
echo 'Go to <a href="/koji/">/koji/</a>' > /var/www/html/index.html
mkdir -p /mnt/koji
cd /mnt/koji
mkdir -p {packages,repos,work,scratch,repos-dist}
chown apache:apache *

setsebool -P allow_httpd_anon_write=1
semanage fcontext -a -t public_content_rw_t "/mnt/koji(/.*)?"
restorecon -r -v /mnt/koji
exit 0

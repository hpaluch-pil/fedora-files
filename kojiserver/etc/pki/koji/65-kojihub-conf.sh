#!/bin/bash
set -xeuo pipefail
f=/etc/kojiweb/web.conf
fqdn=`hostname -f`
kojicert=/etc/pki/koji/certs/kojiadmin.crt
secret=$(openssl rand -hex 10)

sed -i.orig 's@^\(Koji.*URL *= *http://\).*\(/koji.*\)@\1'"$fqdn"'\2@
     s@^\(# \)*\(WebAuthType *= *\).*@\2ssl@
     s@^\(# \)*\(Secret *= *\).*@\2'"$secret"'
     s@^\(# \)*\(WebCert *= *\).*@\2'"$kojicert"'@' $f
diff -u $f{.orig,} || true
httpd -t
exit 0

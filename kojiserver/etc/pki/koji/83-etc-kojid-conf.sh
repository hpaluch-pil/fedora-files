#!/bin/bash
set -xeuo pipefail
f=/etc/kojid/kojid.conf
fqdn=`hostname -f`
kojicert=/etc/pki/koji/kojihub.pem
kojica=/etc/pki/koji/koji_ca_cert.crt
scms="github.com:/hpaluch-pil/clockres.git:no src.fedoraproject.org:/rpms/python-aexpect.git:no:fedpkg,sources github.com:/hpaluch-pil/avocado-vt.git:no:make,source-release,VERSION=109.0"
smtphost=127.0.0.1

sed -i.orig  's@^\(server\|topurl\)\( *= *http://\).*\(/koji.*\)@\1\2'"$fqdn"'\3@
     s@^\(authtype *= *\).*@\1ssl@
     s@^\;\(cert *= *\).*@\1'"$kojicert"'@
     s@^\;\(serverca *= *\).*@\1'"$kojica"'@
     s@^\(allowed_scms *= *\).*@\1'"$scms"'@
     s@^\(smtphost *= *\).*@\1'"$smtphost"'@
     s@^\;* *\(sleeptime *= *\).*@\11@
     ' $f
diff -u $f{.orig,} || true
exit 0

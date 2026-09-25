#!/bin/bash
# Build Henryk's python-aexpect project for Fedora44 using local Koji installation
set -euo pipefail

[ `id -u` -ne 0 ] || { echo "ERROR: This script must be run as regular (non-root) user"'!' >&2; exit 1; }
# note: commit id is latest from branch: koji/master because Koji requires Makefile with
#       'sources' target that builds source tarball from git source
set -x
koji list-pkgs --quiet  --tag dist-f44 | grep -w python-aexpect || {
	# we must add package to distribution - otherwise only --scratch is allowed
	koji add-pkg --owner kojiadmin dist-f44 python-aexpect
}
koji list-pkgs --tag dist-f44
koji build --draft dist-f44 'git+https://src.fedoraproject.org/rpms/python-aexpect.git#888ef28cb9c9abff2e0e3e99538d2528cef4dd36'
exit 0

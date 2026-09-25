#!/bin/bash
# Build Misbah's avocado-plugins-vt project for Fedora44 using local Koji installation
set -euo pipefail

pkg=avocado-plugins-vt
[ `id -u` -ne 0 ] || { echo "ERROR: This script must be run as regular (non-root) user"'!' >&2; exit 1; }
# note: commit id is latest from branch: koji/master because Koji requires Makefile with
#       'sources' target that builds source tarball from git source
set -x
koji list-pkgs --quiet  --tag dist-f44 | grep -w $pkg || {
	# we must add package to distribution - otherwise only --scratch is allowed
	koji add-pkg --owner kojiadmin dist-f44 $pkg
}
koji list-pkgs --tag dist-f44
koji build --draft dist-f44 'git+https://github.com/hpaluch-pil/avocado-vt.git#1db812681afff22e388f1bda1c8f14bf0b5b116d'
exit 0

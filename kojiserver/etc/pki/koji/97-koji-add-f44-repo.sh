#!/bin/bash
# Add external Fedora 44 repo to koji
# This script is based on: https://github.com/RussianFedora/koji-setup file: koji-add
set -xeuo pipefail

[ `id -u` -ne 0 ] || { echo "ERROR: This script must be run as regular (non-root) user"'!' >&2; exit 1; }

TYPE=f
VERSION=44

DIST=dist-${TYPE}${VERSION}
DIST_BUILD=${DIST}-build

koji add-tag ${DIST}
koji add-tag --parent ${DIST} --arches "x86_64" ${DIST_BUILD}

ADD_EXTERNAL_REPO="koji add-external-repo -t ${DIST_BUILD} ${DIST}"

${ADD_EXTERNAL_REPO}-release -p 5 https://ftp.linux.cz/pub/linux/fedora/linux/releases/$VERSION/Everything/\$arch/os/
${ADD_EXTERNAL_REPO}-updates -p 0 https://ftp.linux.cz/pub/linux/fedora/linux/updates/$VERSION/Everything/\$arch/
FEDORA_RELEASE="fedora-release"

koji add-target ${DIST} ${DIST_BUILD}

# Add group build
koji add-group ${DIST_BUILD} build
koji add-group-pkg ${DIST_BUILD} build \
	bash				\
	bzip2				\
	coreutils			\
	cpio				\
	diffutils			\
	$FEDORA_RELEASE			\
	findutils			\
	gawk				\
	gcc				\
	gcc-c++				\
	glibc				\
	grep				\
	gzip				\
	info				\
	make				\
	patch				\
	python				\
	redhat-rpm-config		\
	rpm-build			\
	rpmdevtools			\
	sed				\
	shadow-utils			\
	tar				\
	unzip				\
	util-linux-ng			\
	fedpkg-minimal			\
	which

# Add Group srpm-build
koji add-group ${DIST_BUILD} srpm-build
koji add-group-pkg ${DIST_BUILD} srpm-build \
	bash				\
	bzr				\
	curl				\
	cvs				\
	$FEDORA_RELEASE			\
	git				\
	gnupg				\
	make				\
	python				\
	redhat-rpm-config		\
	rpm-build			\
	rpmdevtools			\
	shadow-utils			\
	subversion			\
	fedpkg-minimal			\
	tar

koji regen-repo ${DIST_BUILD}
exit 0

#!/bin/sh

# Build the package whose builder spec is given in $1.

PRE()  { return; }
POST() { return; }
source $1

tmpdir=`mktemp -d -t ${PKGID}`      || exit 1
echo "Building in ${tmpdir}"    >&2

tar_fname=${tmpdir}/`basename ${TAR_URL}`

curl ${TAR_URL} -o ${tar_fname}     || exit 1
tar -C ${tmpdir} -xzf ${tar_fname}  || exit 1

PRE
(cd ${tmpdir}/${PKGID}; cabal install "${CABAL_INSTALL_OPTIONS[@]}")
POST

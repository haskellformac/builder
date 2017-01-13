#!/bin/sh

# Build the package whose builder spec is given in $1.

export MACOSX_DEPLOYMENT_TARGET=10.11
PRE()  { return; }
POST() { return; }
source "`dirname $0`/../packages/$1"

tmpdir=`mktemp -d -t ${PKGID}`            || exit 1
echo "Building in ${tmpdir}"              >&2

subdir=""
if [ -n "${TAR_URL}" ]; then
  
  tar_fname=${tmpdir}/`basename ${TAR_URL}`
  
  curl ${TAR_URL} -o ${tar_fname}         || exit 1
  tar -C ${tmpdir} -xzf ${tar_fname}      || exit 1

elif [ -n "${GIT_URL}" ]; then
  
  repo_fname="${tmpdir}/${PKGID}"
  
  git clone --depth 1 ${GIT_URL} "${repo_fname}"    || exit 1

  if [ -n "${GIT_SUBDIR}" ]; then
    subdir="/${GIT_SUBDIR}"
  fi
  
else

  mkdir -p ${tmpdir}/${PKGID}  
  cabal_target=${PKGID}
  
fi

# NB: The explicit --builddir option is important when $cabal_target is not empty.
PRE   || exit 1
(cd "${tmpdir}/${PKGID}${subdir}"; \
 cabal install --builddir=${tmpdir}/${PKGID}/dist --reinstall --force-reinstalls "${CABAL_INSTALL_OPTIONS[@]}" ${cabal_target})   || exit 1
POST

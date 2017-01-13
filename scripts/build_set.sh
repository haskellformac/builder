#!/bin/sh

# Build the package set whose builder spec is given. The builder spec is given in $1 if this is the only argument,
# or it is given in $2 if $1 is one of the commands 'install' or 'archive'. If no command is given, we both install
# and archive.
#
# NB: This is a rather simplistic first implementation. It relies on the builder spec for the set to explicitly specify
#     the order in which packages need to be built and doesn't support parallel building of independent packages.

case "$1" in
  install | archive) 
    CMDS=$1
    BUILDER="`dirname $0`/../sets/$2";;
  *)
    CMDS=(install archive)
    BUILDER="`dirname $0`/../sets/$1";;
esac

source ${BUILDER}
libdir=`ghc --print-libdir`

dittoAndRewrite() {
  local tmpdir="$1"
  local pkgid=$2
  local pkgkey=`ghc-pkg --global field ${pkgid} key | cut -d ' ' -f2`
  local pkgfullid=`ghc-pkg --global field ${pkgid} id | cut -d ' ' -f2`

  echo "Including ${pkgid}"                       >&2
  ditto "${libdir}/${pkgkey}" "${tmpdir}/${pkgkey}"
  sed -e 's|/Users/.*/Library/Containers|\$CONTAINERS|g' \
      <"${libdir}/package.conf.d/${pkgfullid}.conf" >"${tmpdir}/package.conf.d/${pkgfullid}.conf"
}

all_packages=()
for set in ${DEPENDENCIES[@]}; do
  set_path=`dirname $0`/../sets/${set}
  all_packages=(${all_packages[@]} `sh -c "source \"${set_path}\"; echo \\${PACKAGES[@]}"`)
done
all_packages=(${all_packages[@]} ${PACKAGES[@]})

for cmd in "${CMDS[@]}"; do
  
  case ${cmd} in

    install) 
      echo "Installing ${SETID}..."               >&2
      for package in "${all_packages[@]}"; do
        ./build_package.sh ${package}
      done
      ;;

    archive)
      tmpdir=`mktemp -d -t ${SETID}`              || exit 1
      echo "Archiving ${SETID} in ${tmpdir}..."   >&2
      mkdir -p "${tmpdir}/package.conf.d"
      for package in "${all_packages[@]}"; do
        dittoAndRewrite "${tmpdir}" ${package}
      done
      tar -cjf ${SETID}.tar.bz2 -C "${tmpdir}" .
      rm -rf "${tmpdir}"
      ;;

    *)
      echo "unknown command: ${cmd}"
      exit 1;;

  esac
  
done
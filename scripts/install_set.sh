#!/bin/sh

# Install the package set archive provided in $1.

archive=`basename $1`
libdir=`ghc --print-libdir`

tmpdir=`mktemp -d -t ${archive}`                || exit 1
echo "Unarchiving ${archive} to ${tmpdir}..."   >&2

tar -xzf $1 -C "${tmpdir}"

for pkgconf in `ls "${tmpdir}"/package.conf.d/*.conf`; do
  sed -e "s|\$CONTAINERS|${HOME}/Library/Containers|g" <"${pkgconf}" >"${pkgconf}.local"
  mv -f "${pkgconf}.local" "${pkgconf}"
  pkgfullid=`basename "${pkgconf}" .conf`
  nameversion=(`ghc-pkg --global --ipid field "${pkgfullid}" name,version | cut -d ' ' -f2`)
  echo "Installing ${nameversion[0]}-${nameversion[1]}"
done

ditto "${tmpdir}" "${libdir}"
ghc-pkg recache

rm -rf "${tmpdir}"

#!/bin/sh
pkgname="apacman"
manpages="apacman.8 apacman.conf.5"
tester="bats"
unit="test.bats"
tmpdir="${TMPDIR:-/tmp}"

err() {
  echo "$@"
  echo "==> Release not ready"
  exit 1
}

manual2html() {
  mkdir -p docs/
  for manual in $manpages; do
    output="docs/${manual}.html"
    [ -f "$output" ] && hash=$(md5sum "$output");
    cat "$manual" | groff -mandoc -Thtml | grep -v "^<\!--" > "docs/${manual}.html"
    echo "$hash" | md5sum -c &>/dev/null ||
    echo "==> Generating docs/${manual}.html"
  done
}

compare2rel() {
  lastrel=$(git tag 2>/dev/null | tail -n 1)
  if [[ "$lastrel" ]]; then
    tagged=$(git log -1 --pretty=oneline $lastrel | awk '{print $1}')
    head=$(git log -1 --pretty=oneline HEAD | awk '{print $1}')
    if [ "$tagged" = "$head" ]; then
      return 0
    fi
  fi
  return 1
}

testunits() {
  echo "==> Run unit tests"
  $tester "$unit" 2>&1 &>/dev/null
  return $?
}

createarchive() {
  newrel="${lastrel#v}"
  if [ ! -z "$newrel" ]; then
    mkdir -p "$tmpdir/${pkgname}-${newrel}" &&
    find . -maxdepth 1 -type f -exec cp {} "$tmpdir/${pkgname}-${newrel}/" \; &&
    cd "$tmpdir" &&
    tar -czvf "${pkgname}-${newrel}.tar.gz" "${pkgname}-${newrel}/" &&
    echo "==> ${pkgname}-${newrel}.tar.gz" &&
    return 0
  fi
  return 1
}

manual2html
staging=$(git status -s --untracked-files=no 2>/dev/null)
ready=$(echo "$staging" | grep -v ^$ | wc -l)
[ "$ready" -eq 0 ] || err "$staging"
testunits || err ":: Unit tests failed"
compare2rel || err ":: HEAD not tagged"
createarchive || err ":: Unable to create archive"
echo "==> Release ready"

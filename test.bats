#!/usr/bin/env bats

APACMAN="./apacman"
RPCURL="https://aur.archlinux.org/rpc/?v=5&type"
fakedir="${TMPDIR:-/tmp}/testing"
testing="--testing"
noconfirm="--noconfirm"
buildonly="--buildonly"
skipcache="--skipcache"
goodpkg="apacman"
badpkg="afuse"
fakepkg="xxxxxx"
corepkg="filesystem"
grouppkg="ladspa-plugins"
virtualpkg="ttf-font"


@test "test command is found" {
  run $APACMAN
  [ "$status" -ne 127 ]
}

@test "invoking without arguments prints usage" {
  run $APACMAN
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "usage: apacman <operation> [option] [package] [package] [...]" ]
}

@test "invoke with nonexistent parameter returns 1" {
  run $APACMAN --falseflag
  [ "$status" -eq 1 ]
}

@test "invoking with '--help' parameter prints usage" {
  run $APACMAN -h
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "usage: apacman <operation> [option] [package] [package] [...]" ]
}

@test "invoke with '--version' parameter prints ascii art" {
  result="$($APACMAN -V | tr -dc '=' | wc -c)"
  [ "$result" -eq 40 ]
}

@test "invoke with '--verbose' parameter without package argument" {
  run $APACMAN -v
  [ "$status" -eq 1 ]
  [ "${lines[-1]}" = "error: must specify a package." ]
}

@test "test internet connectivity" {
  run timeout 5 curl -LfGs --data-urlencode "arg=$goodpkg" "$RPCURL=info"
  [ "$status" -eq 0 ]
}

@test "interactive search install package" {
  run $APACMAN $testing $noconfirm $buildonly $skipcache $goodpkg <<< $(echo -e "0\n")
  [ "$status" -eq 0 ]
}

@test "interactive search install nonexistant package" {
  run $APACMAN $testing $noconfirm $buildonly $skipcache $fakepkg <<< $(echo -e "0\n")
  [ "$status" -eq 1 ]
}

@test "invoke with '-S' parameter installs package from AUR" {
  run $APACMAN $testing $noconfirm $buildonly $skipcache -S $goodpkg
  [ "$status" -eq 0 ]
}

@test "invoke with '-S' parameter fails to build broken package from AUR" {
  run $APACMAN $testing $noconfirm $buildonly $skipcache -S $badpkg
  [ "$status" -eq 1 ]
}

@test "invoke with '-S' parameter installs cached AUR package" {
  run $APACMAN $testing $noconfirm $buildonly -S $goodpkg
  [ "$status" -eq 0 ]
}

@test "invoke with '-S' parameter installs non-AUR package" {
  run $APACMAN $testing $noconfirm -S $corepkg
  [ "$status" -eq 0 ]
}

@test "invoke with '-S' parameter fails to install nonexistant package" {
  run $APACMAN $testing $noconfirm $buildonly $skipcache -S $fakepkg
  [ "$status" -eq 1 ]
}

@test "prepare proot environment" {
  rm -rf "$fakedir"
  run mkdir -p ${fakedir}/var/lib/pacman
  [ "$status" -eq 0 ]
  run fakeroot proot -b ${fakedir}/var:/var pacman -Sy
  [ "$status" -eq 0 ]
}

@test "invoke with '-S' parameter install package group" {
  result=$(proot -b "${fakedir}/var:/var" $APACMAN $testing -S $grouppkg --noconfirm --buildonly <<< $(echo -e "\n") 2>&1)
  status=$?
  [ "$status" -eq 0 ]
  pattern="There are 13 members in group $grouppkg"
  match=$(echo "$result" | grep -o "$pattern")
  [ "$match" = "$pattern" ]
}

@test "invoke with '-S' parameter install virtual package" {
  result=$(proot -b "${fakedir}/var:/var" $APACMAN $testing -S $virtualpkg --noconfirm --buildonly <<< $(echo -e "\n") 2>&1)
  status=$?
  [ "$status" -eq 0 ]
  pattern="There are 10 packages that provide $virtualpkg"
  match=$(echo "$result" | grep -o "$pattern")
  [ "$match" = "$pattern" ]
}

@test "clean proot environment" {
  run rm -rf "$fakedir"
  [ "$status" -eq 0 ]
}

###########

@test "invoke with '-L' parameter lists installed packages by size" {
  result="$($APACMAN -L | grep '\B[0-9][BKMG][ \t]*[a-z]' | awk NR==1)"
  [ ! -z "$result" ]
}

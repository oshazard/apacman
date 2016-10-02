#!/usr/bin/env bats

APACMAN="./apacman"
RPCURL="https://aur.archlinux.org/rpc/?v=5&type"
flag1="--testing"
flag2="--noconfirm"
flag3="--buildonly"
flag4="--skipcache"
goodpkg="apacman"
badpkg="afuse"
fakepkg="xxxxxx"
corepkg="which"


@test "test command is found" {
  run $APACMAN
  [ "$status" -ne 127 ]
}

@test "invoking without arguments prints usage" {
  run $APACMAN
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "usage: apacman [option] [package] [package] [...]" ]
}

@test "invoke with nonexistent parameter returns 1" {
  run $APACMAN --falseflag
  [ "$status" -eq 1 ]
}

@test "invoking with '--help' parameter prints usage" {
  run $APACMAN -h
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "usage: apacman [option] [package] [package] [...]" ]
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
  run $APACMAN $flag1 $flag2 $flag3 $flag4 $goodpkg <<< $(echo -e "0\n")
  [ "$status" -eq 0 ]
}

@test "interactive search install nonexistant package" {
  run $APACMAN $flag1 $flag2 $flag3 $flag4 $fakepkg <<< $(echo -e "0\n")
  [ "$status" -eq 1 ]
}

@test "invoke with '-S' parameter installs package from AUR" {
  run $APACMAN $flag1 $flag2 $flag3 $flag4 -S $goodpkg
  [ "$status" -eq 0 ]
}

@test "invoke with '-S' parameter fails to build package from AUR" {
  run $APACMAN $flag1 $flag2 $flag3 $flag4 -S $badpkg
  [ "$status" -eq 1 ]
}

@test "invoke with '-S' parameter installs cached AUR package" {
  run $APACMAN $flag1 $flag2 $flag3 -S $goodpkg
  [ "$status" -eq 0 ]
}

@test "invoke with '-S' parameter installs non-AUR package" {
  run $APACMAN $flag1 $flag2 -S $corepkg
  [ "$status" -eq 0 ]
}

@test "invoke with '-S' parameter fails to install nonexistant package" {
  run $APACMAN $flag1 $flag2 $flag3 $flag4 -S $fakepkg
  [ "$status" -eq 1 ]
}

###########

@test "invoke with '-L' parameter lists installed packages by size" {
  result="$($APACMAN -L | grep '\B[0-9][BKMG][ \t]*[a-z]' | awk NR==1)"
  [ ! -z "$result" ]
}

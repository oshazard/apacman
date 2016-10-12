apacman
==================

ArchLinux User Repository ([AUR](https://aur.archlinux.org/packages/)) helper and pacman wrapper

**Chat room:** [![gitter](https://img.shields.io/gitter/room/apacman/gitter.svg?maxAge=2592000)](https://gitter.im/apacman/Lobby)

**Comments:** [![AUR package](https://img.shields.io/aur/version/apacman.svg?label=AUR%20package&maxAge=2592000&style=plastic)](https://aur.archlinux.org/packages/apacman/)

------------

**Total:**   [![all downloads badge](https://img.shields.io/github/downloads/oshazard/apacman/total.svg)](https://github.com/oshazard/apacman/releases)

**Previous:** [![previous release badge](https://img.shields.io/github/downloads/oshazard/apacman/v2.6/total.svg)](https://github.com/oshazard/apacman/releases/tag/v2.6) [![previous release badge](https://img.shields.io/github/downloads/oshazard/apacman/v2.9/total.svg)](https://github.com/oshazard/apacman/releases/tag/v2.9)

**Current:**  [![downloads badge](https://img.shields.io/github/downloads/oshazard/apacman/latest/total.svg)](https://github.com/oshazard/apacman/releases/latest)

**Votes:**    [![Votes](https://img.shields.io/aur/votes/apacman.svg)](https://aur.archlinux.org/packages/apacman/) [![Stars](https://img.shields.io/github/stars/oshazard/apacman.svg?style=social)](https://github.com/oshazard/apacman/stargazers)
<sup>(if you like this software, please upvote it on AUR)</sup>


See also
------------

[![apacman-utils](https://img.shields.io/aur/version/apacman-utils.svg?label=apacman-utils)](https://aur.archlinux.org/packages/apacman-utils/) [<sup>(AUR uploader)</sup>](https://github.com/oshazard/apacman-utils/blob/master/aurpush) [<sup>(Migrate wizard for AUR4)</sup>](https://github.com/oshazard/apacman-utils/blob/master/apac-migrate)

[Forked](https://github.com/keenerd/packer/pull/141) from [packer](https://github.com/keenerd/packer)


Installation:
==========
1. `pacman -S --needed --asdeps jshon`
2. `curl -O "https://raw.githubusercontent.com/oshazard/apacman/master/apacman"`
3. `bash ./apacman -S apacman`
4. `apacman -S apacman-deps` (_optional_)


Documentation:
==========
* [`man 8 apacman`](https://oshazard.github.io/apacman/apacman.8.html)
* [`man 5 apacman.conf`](https://oshazard.github.io/apacman/apacman.conf.5.html)


Changelog:
==========

Version 3.0
----------
* **NEW** Add alternative --flag=parameter syntax for relevant options
* **NEW** Fix for installing groups and virtual packages
* **NEW** Fix to allow installing cached packages without Internet
* **NEW** Implement unit tests using [bats](https://github.com/sstephenson/bats) (WIP)
* **NEW** Add regex/wildcard support to -S and -Ss
* **NEW** Return code 1 on errors
* **NEW** Improve viewing package comments
* **NEW** Update manpages
* Closed 10+ issues since last release

Version 2.9
-----------
* -P parameter uses AUR passthrough for pkgfile
* Save installed AUR package metadata to database
* --nodatabase parameter does not store AUR database
* --gendb parameter to generate AUR database files
* Display remaining packages in queue
* --notify parameter for notify-send notifications
* --noprogress to disable transaction progress
* Enabled terminal title progress by default
* --edit parameter to override 'noedit' option in config file
* fix CLI flag precedence over config file

Version 2.6
-----------
* improve -U to display packages removed from AUR as "unresolvable"
* bug fix for --devel
* merged fix that improves curl debugging
* merged fix that removes split package support
* merged pull requests for AUR5 support
* improved virtual package support
* improved -U handling
* -W parameter to view package comments
* sanity checks for curl with debugging
* fixes for ABS
* improved signed package support
* --keepkeys parameter stores PGP keys
* --purgekeys parameter removes trusted PGP keys
* fix for piping output
* fix for yes/no dialog

Version 2.0
-----------
* Split package support and shared source
* Improved AUR4 support
* Bug fix for AUR4 -Si
* Bug fix for built/failed
* --legacy flag for AUR3
* Preliminary AUR4 support
* Signed package support

Version 1.6
-----------
* Display [installed], [installed: VER], or [local: VER] in -Ss
* --progress parameter sets terminal title to package status
* Add AUR link to -Si info
* Bug fix for saved AUR packages and --cachevcs
* Bug fix for pacmatic
* Build status log
* Override EDITOR for PKGBUILDs in config file
* --buildonly parameter to build but not AUR install packages
* --nofail parameter to quit if a package does not build
* --purgebuild parameter to remove unneeded build depends
* --skiptest to avoid installing unit test packages

Version 1.0
-----------
* Config file support (/etc/apacman.conf)
* Cleaned up manpages
* Replacement for pacsysclean (-L list installed packages by size)
* -G now supports ABS + AUR packages
* --noaur parameter to skip AUR packages
* --warn parameter makes errors non-fatal (only enable if you know what you are doing)
* Run as root workaround for Pacman 4.2+

Version 0.6
-----------
* All features from packer
* Saves built AUR packages to /var/cache/apacman/pkg
* Uses AUR package cache directory if applicable
* --needed parameter that does not install up-to-date packages
* --ignorearch parameter that ignores architectures specified in PKGBUILD (useful for ARM devices)
* --skipcache parameter that skips check for pre-built package in cache directory
* --cachevcs parameter installs cached VCS (git, svn, hg) packages newer than AUR PKGBUILDs
* Partial passthrough support for -R, -Q, and -U pacman parameters

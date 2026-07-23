#!/usr/bin/env bash
# lib/distro.sh — detect distro family and pick the package backend
# Sets: DISTRO_ID, DISTRO_PRETTY, PKG_FAMILY (deb|rpm|arch|none), PKG_TOOL (apt|dnf|pacman|"")

DISTRO_ID="" DISTRO_LIKE="" DISTRO_PRETTY="" PKG_FAMILY="none" PKG_TOOL=""

if [[ -r /etc/os-release ]]; then
  DISTRO_ID=$(. /etc/os-release && echo "${ID:-}")
  DISTRO_LIKE=$(. /etc/os-release && echo "${ID_LIKE:-}")
  DISTRO_PRETTY=$(. /etc/os-release && echo "${PRETTY_NAME:-}")
fi

_distro_matches() { # succeeds if ID or ID_LIKE contains any of the given words
  local w
  for w in $DISTRO_ID $DISTRO_LIKE; do
    case " $* " in *" $w "*) return 0 ;; esac
  done
  return 1
}

if have apt-get && _distro_matches debian ubuntu linuxmint pop; then
  PKG_FAMILY="deb"  PKG_TOOL="apt"
elif have dnf && _distro_matches fedora rhel centos rocky almalinux; then
  PKG_FAMILY="rpm"  PKG_TOOL="dnf"
elif have pacman && _distro_matches arch archlinux manjaro endeavouros; then
  PKG_FAMILY="arch" PKG_TOOL="pacman"
# os-release inconclusive: judge by which package manager exists
elif have apt-get; then PKG_FAMILY="deb"  PKG_TOOL="apt"
elif have dnf;     then PKG_FAMILY="rpm"  PKG_TOOL="dnf"
elif have pacman;  then PKG_FAMILY="arch" PKG_TOOL="pacman"
fi

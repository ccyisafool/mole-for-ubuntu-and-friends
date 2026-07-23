#!/usr/bin/env bash
# lib/pkg.sh — package-manager abstraction over the deb/rpm/arch families.
# Every mole command talks to these six functions, never to apt/dnf/pacman directly.

pkg_list_manual() { # manually-installed package names, one per line
  case "$PKG_FAMILY" in
    deb)  apt-mark showmanual 2>/dev/null | sort ;;
    rpm)  dnf repoquery --userinstalled --qf '%{name}\n' 2>/dev/null | sort -u ;;
    arch) pacman -Qeq 2>/dev/null ;;
  esac
}

pkg_remove() { # remove one package incl. its config where the manager supports it
  case "$PKG_FAMILY" in
    deb)  run_root apt-get remove --purge -y "$1" ;;
    rpm)  run_root dnf remove -y "$1" ;;
    arch) run_root pacman -Rns --noconfirm "$1" ;;
    *)    err "no package backend on this system"; return 1 ;;
  esac
}

pkg_autoremove() { # drop packages nothing depends on anymore
  case "$PKG_FAMILY" in
    deb)  run_root apt-get autoremove --purge -y ;;
    rpm)  run_root dnf autoremove -y ;;
    arch)
      local orphans
      orphans=$(pacman -Qdtq 2>/dev/null)
      if [[ -n $orphans ]]; then
        # shellcheck disable=SC2086
        run_root pacman -Rns --noconfirm $orphans
      else
        info "${C_DIM}no orphaned packages${C_RESET}"
      fi
      ;;
  esac
}

pkg_clean_cache() { # empty the downloaded-package cache
  case "$PKG_FAMILY" in
    deb)  run_root apt-get clean ;;
    rpm)  run_root dnf clean all ;;
    arch) run_root pacman -Scc --noconfirm ;;
  esac
}

pkg_autoclean() { # drop only obsolete entries from the cache (optimize's gentler variant)
  case "$PKG_FAMILY" in
    deb)  run_root apt-get autoclean -y ;;
    rpm)  run_root dnf clean packages ;;
    arch) run_root pacman -Sc --noconfirm ;;
  esac
}

pkg_cache_path() { # where downloaded packages live (for size display)
  case "$PKG_FAMILY" in
    deb)  echo /var/cache/apt/archives ;;
    rpm)  [[ -d /var/cache/libdnf5 ]] && echo /var/cache/libdnf5 || echo /var/cache/dnf ;;
    arch) echo /var/cache/pacman/pkg ;;
  esac
}

#!/usr/bin/env bash
# install-shairport-sync.sh
#
# Installs shairport-sync from source on Debian/Ubuntu.
#
# Usage:
#   ./install-shairport-sync.sh
#   ./install-shairport-sync.sh --branch master
#   ./install-shairport-sync.sh --prefix /usr/local
#
# Notes:
# - Requires sudo privileges.
# - Builds in a temporary working directory.
# - Enables and starts the shairport-sync systemd service.

set -Eeuo pipefail

# ---------- Config defaults ----------
REPO_URL="https://github.com/mikebrady/shairport-sync.git"
BRANCH="master"
PREFIX="/usr/local"

WORKDIR=""
CLEANUP=true

# ---------- Helpers ----------
log()  { printf "\n[%s] %s\n" "$(date +'%F %T')" "$*"; }
warn() { printf "\n[WARN] %s\n" "$*" >&2; }
die()  { printf "\n[ERROR] %s\n" "$*" >&2; exit 1; }

usage() {
  cat <<EOF
Install shairport-sync from source (Debian/Ubuntu).

Options:
  --branch <name>    Git branch or tag to build (default: ${BRANCH})
  --prefix <path>    Install prefix (default: ${PREFIX})
  --no-cleanup       Keep temporary build directory
  -h, --help         Show this help

Example:
  ./install-shairport-sync.sh --branch master --prefix /usr/local
EOF
}

cleanup() {
  if [[ -n "${WORKDIR}" && -d "${WORKDIR}" && "${CLEANUP}" == "true" ]]; then
    log "Cleaning up ${WORKDIR}"
    rm -rf "${WORKDIR}"
  else
    [[ -n "${WORKDIR}" ]] && log "Build directory kept at: ${WORKDIR}"
  fi
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

# ---------- Arg parsing ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --branch)   BRANCH="${2:-}"; shift 2 ;;
    --prefix)   PREFIX="${2:-}"; shift 2 ;;
    --no-cleanup) CLEANUP=false; shift ;;
    -h|--help)  usage; exit 0 ;;
    *) die "Unknown argument: $1 (use --help)" ;;
  esac
done

trap cleanup EXIT

# ---------- Pre-flight ----------
require_cmd sudo
require_cmd git
require_cmd make

log "Updating package lists"
sudo apt-get update -y

log "Installing build dependencies"
sudo apt-get install -y \
  autoconf \
  automake \
  avahi-daemon \
  build-essential \
  git \
  libasound2-dev \
  libavahi-client-dev \
  libconfig-dev \
  libdaemon-dev \
  libpopt-dev \
  libssl-dev \
  libtool \
  xmltoman

# ---------- Build ----------
WORKDIR="$(mktemp -d -t shairport-sync-build-XXXXXX)"
log "Working directory: ${WORKDIR}"
cd "${WORKDIR}"

log "Cloning repository: ${REPO_URL} (branch/tag: ${BRANCH})"
git clone --depth 1 --branch "${BRANCH}" "${REPO_URL}" shairport-sync

cd shairport-sync

log "Running autoreconf"
autoreconf -i -f

log "Configuring"
./configure \
  --prefix="${PREFIX}" \
  --with-alsa \
  --with-avahi \
  --with-ssl=openssl \
  --with-systemd \
  --with-metadata

log "Building"
make -j"$(nproc)"

log "Installing"
sudo make install

# ---------- Service setup ----------
if command -v systemctl >/dev/null 2>&1; then
  log "Enabling and starting shairport-sync (systemd)"
  sudo systemctl daemon-reload || true
  sudo systemctl enable --now shairport-sync

  log "Service status (non-fatal if it fails)"
  sudo systemctl --no-pager status shairport-sync.service || true
else
  warn "systemctl not found; attempting to start via service command"
  sudo service shairport-sync start || true
fi

log "Done ✅"

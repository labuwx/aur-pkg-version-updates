#!/bin/bash -eux
set -o pipefail

WORKDIR="workdir"
mkdir "${WORKDIR}"

AUR_REPO_URL="ssh://aur@aur.archlinux.org/raspberrypi-devicetree-git.git"
AUR_REPO_DIR="${WORKDIR}/aur_repo_dir"
RPIFW_REPO_URL="https://github.com/raspberrypi/firmware.git"
RPIFW_REPO_DIR="${WORKDIR}/rpi_fw_dir"

git clone "${AUR_REPO_URL}" "${AUR_REPO_DIR}"
git clone --filter=blob:none --no-checkout "${RPIFW_REPO_URL}" "${RPIFW_REPO_DIR}"

cd "${RPIFW_REPO_DIR}"
latest_tag=$(git tag -l --sort=-version:refname "1.20*" | head -n 1)
cd -

cd "${AUR_REPO_DIR}"
pkgver=$(sed -nE 's/^\s*pkgver\s*=\s*(1\.20[[:digit:]]{6})\s*$/\1/p' ".SRCINFO")

if [[ "$latest_tag" == "$pkgver" ]]; then
    echo "AUR package is already up-to-date."
    exit 0
fi

echo "Updating AUR package to version ${latest_tag} ."

sedexp="s/^(\s*pkgver\s*=\s*)(1\.20[[:digit:]]{6})(\s*)$/\1${latest_tag}\3/"
sed -i -E "${sedexp}" ".SRCINFO"
sed -i -E "${sedexp}" "PKGBUILD"

git add ".SRCINFO" "PKGBUILD"
git commit --message "Version: ${latest_tag}"
git push

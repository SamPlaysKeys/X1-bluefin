#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# dnf5 -y copr enable abn/throttled
dnf5 -y copr enable sneexy/python-validity

dnf5 -y install niri noctalia
dnf5 -y install fprintd-clients fprintd-clients-pam open-fprintd python3-validity fprintd fprintd-pam
dnf5 -y install grim slurp wl-clipboard

# Force authselect to update system PAM configuration 
authselect enable-feature with-fingerprint

dnf5 -y remove tuned tuned-ppd
dnf5 -y install tlp tlp-rdw zcfan
# dnf5 -y install throttled

# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable abn/throttled
dnf5 -y copr disable sneexy/python-validity

# Install Hack Nerd Font
mkdir -p /usr/share/fonts/hack-nerd-font
curl -sSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz | tar -xJ -C /usr/share/fonts/hack-nerd-font
fc-cache -f /usr/share/fonts/hack-nerd-font

systemctl enable tlp.service
systemctl enable zcfan.service
systemctl enable open-fprintd.service python3-validity.service open-fprintd-resume.service open-fprintd-suspend.service
systemctl mask systemd-rfkill.service systemd-rfkill.socket

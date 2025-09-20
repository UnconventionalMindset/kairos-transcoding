FROM quay.io/kairos/fedora:40-standard-amd64-generic-v3.5.3-k3s-v1.33.4-k3s1

RUN dnf remove -y NetworkManager

RUN dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y \
    systemd-networkd \
    intel-gpu-firmware \
    iscsi-initiator-utils \
    neovim \
    qemu-guest-agent \
    nfs-utils \
    go \
    igt-gpu-tools \
    intel-opencl \
    intel-media-driver && \
    dnf clean all

RUN systemctl disable firewalld
RUN systemctl enable systemd-networkd
RUN systemctl enable iscsid.service
RUN export VERSION="40-container-transcoding-2.0.3-kairos-3.5.3-k3s-1.33.4"
RUN cat > /etc/os-release << 'EOF'
NAME="Fedora Linux"
VERSION_ID=40
PRETTY_NAME="Kairos - Fedora Linux (Container) - transcoding"
ANSI_COLOR="0;38;2;60;110;180"
logo=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:40"
DEFAULT_HOSTNAME="fedora"
VARIANT="Container Image - Transcoding"
VARIANT_ID=transcoding
OS_NAME="kairos-fedora-transcoding"
OS_VERSION="40-2.0.3"
OS_ID="kairos"
OS_NAME="kairos-fedora-transcoding"
BUG_REPORT_URL="https://github.com/UnconventionalMindset/kairos-transcoding/issues"
HOME_URL="https://github.com/UnconventionalMindset/kairos-transcoding"
OS_REPO="quay.io/repository/unconventionalmindset/kairos-fedora-transcoding"
OS_LABEL="2.0.3-kairos-3.5.3-k3s-1.33.4"
GITHUB_REPO="UnconventionalMindset/kairos-transcoding"
VARIANT="transcoding"
FLAVOR="fedora"
EOF


FROM quay.io/kairos/fedora:40-standard-amd64-generic-v3.1.1-k3sv1.30.2-k3s1

RUN dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y \
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

RUN systemctl enable iscsid.service
RUN export VERSION="40-container-transcoding-1.0"
RUN envsubst '${VERSION}' </etc/os-release

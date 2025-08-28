FROM quay.io/kairos/fedora:40-standard-amd64-generic-v3.5.2-k3s-v1.33.4-k3s1

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
RUN export VERSION="40-container-transcoding-2.0.0-kairos-3.5.2-k3s-1.33.4"
RUN envsubst '${VERSION}' </etc/os-release

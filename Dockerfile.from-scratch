FROM fedora:40 as base

# Minimum required packages for Kairos to work:
# - An init system (systemd)
# - Grub
# - kernel/initramfs
RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf

RUN dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y \
    audit \
    coreutils \
    curl \
    device-mapper \
    dosfstools \
    dracut \
    dracut-live \
    dracut-network \
    dracut-squash \
    e2fsprogs \
    efibootmgr \
    gawk \
    gdisk \
    grub2 \
    grub2-efi-x64 \
    grub2-efi-x64-modules \
    grub2-pc \
    haveged \
    kernel \
    kernel-modules \
    kernel-modules-extra \
    livecd-tools \
    lvm2 \
    nano \
    NetworkManager \
    openssh-server \
    parted \
    polkit \
    rsync \
    shim-x64 \
    squashfs-tools \
    sudo \
    systemd \
    systemd-networkd \
    systemd-resolved \
    tar \
    which \
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

RUN mkdir -p /run/lock
RUN touch /usr/libexec/.keep

# Copy the Kairos framework files. We use master builds here for fedora. See https://quay.io/repository/kairos/framework?tab=tags for a list
COPY --from=quay.io/kairos/framework:master_fedora / /

# Set the Kairos arguments in os-release file to identify your Kairos image
FROM quay.io/kairos/osbuilder-tools:latest as osbuilder
RUN zypper install -y gettext
RUN mkdir /workspace
COPY --from=base /etc/os-release /workspace/os-release

# You should change the following values according to your own versioning and other details
RUN OS_NAME=kairos-fedora-transcoding \
  OS_VERSION=v1.0.0 \
  OS_ID="kairos" \
  OS_NAME=kairos-fedora-transcoding \
  BUG_REPORT_URL="https://github.com/UnconventionalMindset/kairos-transcoding/issues" \
  HOME_URL="https://github.com/UnconventionalMindset/kairos-transcoding" \
  OS_REPO="quay.io/unconventionalmindset/kairos-fedora-transcoding" \
  OS_LABEL="latest" \
  GITHUB_REPO="UnconventionalMindset/kairos-transcoding" \
  VARIANT="core" \
  FLAVOR="fedora" \
  /update-os-release.sh

FROM base
COPY --from=osbuilder /workspace/os-release /etc/os-release

# Activate Kairos services
RUN systemctl enable cos-setup-reconcile.timer && \
          systemctl enable cos-setup-fs.service && \
          systemctl enable cos-setup-boot.service && \
          systemctl enable cos-setup-network.service

# Activate ISCSI for Longhorn
RUN systemctl enable iscsid.service

## Generate initrd
RUN kernel=$(ls /boot/vmlinuz-* | head -n1) && \
            ln -sf "${kernel#/boot/}" /boot/vmlinuz
RUN kernel=$(ls /lib/modules | head -n1) && \
            dracut -v -N -f "/boot/initrd-${kernel}" "${kernel}" && \
            ln -sf "initrd-${kernel}" /boot/initrd && depmod -a "${kernel}"
RUN rm -rf /boot/initramfs-*

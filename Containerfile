ARG FEDORA_MAJOR_VERSION=39

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

COPY rootfs/ /

RUN rpm-ostree install distrobox && \
    rpm-ostree override remove toolbox && \
    mkdir -p /etc/distrobox && \
    echo "container_image_default=\"registry.fedoraproject.org/fedora-toolbox:$(rpm -E %fedora)\"" >> /etc/distrobox/distrobox.conf && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable dconf-update.service && \
    rpm-ostree cleanup -m && \
    ostree container commit

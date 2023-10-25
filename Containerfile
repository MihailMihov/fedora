ARG FEDORA_MAJOR_VERSION=39

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

COPY rootfs/ /

RUN rpm-ostree override remove firefox firefox-langpacks && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable dconf-update.service && \
    rpm-ostree cleanup -m && \
    ostree container commit

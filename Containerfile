ARG FEDORA_MAJOR_VERSION=39

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

COPY rootfs/ /

RUN wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -P /etc/yum.repos.d/

RUN rpm-ostree override remove firefox firefox-langpacks

RUN rpm-ostree install gnome-tweaks podman-docker tailscale

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable dconf-update.service

RUN rpm-ostree cleanup -m

RUN ostree container commit

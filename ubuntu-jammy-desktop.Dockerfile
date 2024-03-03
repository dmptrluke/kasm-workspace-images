FROM docker.io/kasmweb/ubuntu-jammy-desktop:%VER%-rolling

USER root

# free up space
RUN curl https://raw.githubusercontent.com/apache/flink/02d30ace69dc18555a5085eccf70ee884e73a16e/tools/azure-pipelines/free_disk_space.sh | bash

RUN apt update && apt install -y sudo curl jq wget build-essential python3 python3-pip wireguard openresolv jq libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin
RUN echo "#1000 ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers


WORKDIR /tmp
# https://hub.docker.com/r/rustlang/rust/dockerfile
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    USER=root \
    PATH=/usr/local/cargo/bin:$PATH

# install rust
RUN set -eux; \
    \
    url="https://sh.rustup.rs"; \
    wget "$url" -O rustup-init; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# install 1password
RUN wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
RUN sudo apt install ./1password-latest.deb -y

USER 1000
# install ZSH
RUN sh -c "$(curl -fsSL https://thmr.at/setup/zsh)"
RUN sudo usermod -s /bin/zsh kasm-user

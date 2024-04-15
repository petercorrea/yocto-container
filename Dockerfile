FROM arm64v8/ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat \
    cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
    python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit \
    mesa-common-dev zstd liblz4-tool file locales quilt sudo vim tree iproute2 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG en_US.utf8

# Create a non-root user to run the build
ARG USERNAME
ARG USER_UID
ARG USER_GID

# match container permissions to that of host
RUN useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
RUN chown -R $USERNAME:$USER_GID /home/$USERNAME 
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME

# setup working environment
ENV HOME=/home/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

FROM ubuntu:bionic

ARG CODE_SERVER_VER=3.12.0
ARG DEBIAN_FRONTEND="noninteractive"
ARG TIME_ZONE="Atlantic/Canary"
ARG USERNAME=user
ARG UID=1000
ARG GID=1000

LABEL authors="Marcos Colebrook"
LABEL description="Container image for VS Code and CDR code-server with Development Tools"

WORKDIR /root
ENV TZ=$TIME_ZONE

# VS Code
RUN apt update && \
    apt install -y wget software-properties-common apt-transport-https && \
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
    apt update && \
    apt install -y --no-install-recommends \
    build-essential \
    code \
    dbus \
    dbus-x11 \
    gdb \
    libasound2 \
    libgl1-mesa-glx \
    libx11-dev \
    libx11-xcb1 \
    libxshmfence1 \
    openssh-client \
    sudo && \
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

# code-server
RUN wget -q "https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb" && \
    apt install "./code-server_${CODE_SERVER_VER}_amd64.deb" && \
    rm "code-server_${CODE_SERVER_VER}_amd64.deb"

RUN groupadd -g $GID $USERNAME && \
    useradd -m -u $UID -g $GID -G root,staff $USERNAME -s /bin/bash -c 'code user' && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER $USERNAME
ENV HOME=/home/$USERNAME
WORKDIR $HOME
ENV PATH=$PATH:$HOME/scripts

COPY --chown=user:user scripts/*.sh scripts/

RUN dbus-launch code --extensions-dir .config/Code/extensions --install-extension ms-vscode.cpptools && \
    mkdir -p .config/code-server .local/share/code-server/User && \
    chmod a+x scripts/*.sh && \
    sudo mkdir -p /var/run/dbus && \
    sh -c 'echo "sudo /etc/init.d/dbus start &> /dev/null" >> ${HOME}/.bashrc'

WORKDIR $HOME/src

#CMD [ "/bin/bash" ]

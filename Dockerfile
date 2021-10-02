#FROM debian:stable-slim
#FROM ubuntu:focal
FROM ubuntu:bionic

ARG CODE_SERVER_VER=3.12.0
ARG DEBIAN_FRONTEND="noninteractive"
ARG TIME_ZONE="Atlantic/Canary"
ARG USERNAME=user
ARG UID=1000
ARG GID=1000

LABEL authors="Marcos Colebrook"
LABEL description="Container for VS Code and CDR code-server with Development Tools"

WORKDIR /root
ENV TZ=$TIME_ZONE

# VS Code
RUN apt update && \
    apt install -y wget gpg && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm -f packages.microsoft.gpg && \
    apt update && \
    apt install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    code \
    dbus-x11 \
    gdb \
    libasound2 \
    libgl1-mesa-glx \
    libgtk2.0-0 \
    libx11-dev \
    libx11-xcb1 \
    xnest \
    libxshmfence1 \
    openssh-client \
    sudo \
&& rm -rf /var/lib/apt/lists/*


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
ENV PATH=$PATH:$HOME

RUN sudo mkdir -p /var/run/dbus && \
    sh -c 'echo "sudo dbus-daemon --system &> /dev/null" >> ${HOME}/.bashrc'

RUN mkdir -p $HOME/.local/share/code-server && \
#    code --user-data-dir $HOME/.vscode/Code --extensions-dir $HOME/.vscode/extensions --install-extension ms-vscode.cpptools 
    #wget -q https://github.com/microsoft/vscode-cpptools/releases/download/1.6.0/cpptools-linux.vsix && \
    #code --user-data-dir $HOME/.vscode/Code --install-extension ms-vscode.cpptools-1.7.0-insiders2 && \
    #rm *.vsix && \
    #mkdir -p .vscode/Code/User src && \
    mkdir -p .config/Code/User .vscode src && \
    #code --user-data-dir $HOME/.vscode/Code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode.cpptools
    # && \
    #sudo chown -R $USERNAME:$USERNAME $HOME/.vscode && \
    #sudo chmod -R g+w .vscode

COPY --chown=user:user *.sh ./
COPY --chown=user:user vscode-config/*.json .vscode/
COPY --chown=user:user src/helloworld.cpp src/

#CMD [ "/bin/bash" ]

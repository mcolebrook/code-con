FROM ubuntu:18.04
#FROM ubuntu:bionic

ARG DEBIAN_FRONTEND="noninteractive"
ARG TIME_ZONE="Atlantic/Canary"
ARG USERNAME=user
ARG UID=1000
ARG GID=1000
#ARG CODE_SERVER_VER=3.12.0
ARG CODE_SERVER_VER=4.2.0

LABEL authors="Marcos Colebrook" 
LABEL description="Container image for VS Code and CDR code-server with Development Tools"

WORKDIR /root
ENV TZ=$TIME_ZONE \
    DBUS_SESSION_BUS_ADDRESS="autolaunch:" \
    TEMP=/tmp 
#   LANG="en_US.UTF-8" \
#	LANGUAGE="en_US.UTF-8"

# VS Code
RUN apt update \
    && apt install -y wget software-properties-common apt-transport-https \
    && wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
    && apt update \
    &&  apt install -y --no-install-recommends \
        build-essential \
        code \
        dbus \
        dbus-x11 \
        gdb \
        gnome-keyring \
        iproute2 \
        libasound2 \
        libatk-bridge2.0-0 \
        libcurl4 \
        libfuse2 \
        libgconf-2-4 \
        libgdk-pixbuf2.0-0 \
        libgl1 \
        libgl1-mesa-glx \
        libgtk-3.0 \
        libnotify-bin \
        libsecret-1-dev \
        libssl-dev \
        libx11-dev \
        libx11-xcb-dev \
        libx11-xcb1 \
        libxkbfile-dev \
        libxshmfence1 \
        lsb-release \
        openssh-client \
        python-dbus \
        python-gtk2 \
        python-pip \
        sudo \
        tzdata \
        unzip \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# code-server
RUN wget -q "https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb" \
    && apt install "./code-server_${CODE_SERVER_VER}_amd64.deb" \
    && rm "code-server_${CODE_SERVER_VER}_amd64.deb"

COPY init-dbus.sh /usr/local/share/

RUN mkdir -p /var/run/dbus \
	&& chmod +x /usr/local/share/init-dbus.sh

RUN groupadd --gid $GID $USERNAME && \
    useradd --uid $UID --gid $GID --groups root,staff --create-home --shell /bin/bash --comment 'code user' $USERNAME && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd && \
    echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

USER $USERNAME
ENV HOME=/home/$USERNAME
WORKDIR $HOME
ENV PATH=$PATH:$HOME/scripts

COPY --chown=user:user scripts/*.sh scripts/

#RUN dbus-launch code --extensions-dir .config/Code/extensions --install-extension ms-vscode.cpptools && \
RUN code --extensions-dir .config/Code/extensions --install-extension ms-vscode.cpptools \
    && mkdir -p .config/code-server .local/share/code-server/User \
    && chmod a+x scripts/*.sh 
    #\
#    && sudo mkdir -p /var/run/dbus \
#    && sh -c 'echo "sudo /etc/init.d/dbus start &> /dev/null" >> ${HOME}/.bashrc'

WORKDIR $HOME/src

ENTRYPOINT [ "/usr/local/share/init-dbus.sh export $(dbus-launch); export NSS_USE_SHARED_DB=ENABLED" ]
CMD [ "/bin/bash" ]
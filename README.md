# code-con
> A Docker container image for VS Code and CDR code-server

## Motivation

|     App     |           Pros           |                            Cons                              |
|:-----------:|:------------------------:|:------------------------------------------------------------:|
|     Code    | Full IDE with extensions |                         Desktop app                          |
| code-server |          Web app         | Cannot install MS extensions (violates Term-of-Service, TOS) |

## Uses
- Headless server: run app with X in a remote server.
- Reproducible science: pack all the tools needed for a experiment along with the IDE in order to re-run it.

## Prerequisites

- Docker
- Windows: install MobaXterm to run the X11 server
- Mac: install XQuartz
- Terminal: you may use MobaXterm or any other app


## Install & build up

Move to a specific folder/directory, for instance `c:\temp` in Windows or `\tmp` in Mac, and type the following:

```
git clone http://github.com/mcolebrook/code-con
cd code-con
docker build -t mcolebrook/code-con .
```


## Starting up the image

### Windows

> Note: we are considering that you cloned the project in `c:\temp`. If not, please change the directory accordingly:

```
docker run --rm -it --name code-con --hostname linux \
--cap-add=SYS_ADMIN \
-p 8080:8080 -e DISPLAY=10.209.2.224:0.0  \
--mount type=bind,source=/c/temp/code-con/github/settings/vscode-settings.json,target=/home/user/.config/Code/User/settings.json \
--mount type=bind,source=/c/temp/code-con/github/settings/code-server-settings.json,target=/home/user/.local/share/code-server/User/settings.json \
-v /c/temp/docker/code-con/github/src:/home/user/src \
mcolebrook/code-con
```


### Mac

> Note: we are considering that you cloned the project in `\tmp`. If not, please change the directory accordingly:

```
$ xhost +
$ docker run --rm -it --name code-con --hostname linux \
--cap-add=SYS_ADMIN \
-p 8080:8080 -e DISPLAY=host.docker.internal:0.0  \
-v /tmp/code-con/github/src:/home/user/src \
--mount type=bind,source=/tmp/code-con/github/settings/vscode-settings.json,target=/home/user/.config/Code/User/settings.json \
--mount type=bind,source=/tmp/code-con/github/settings/code-server-settings.json,target=/home/user/.local/share/code-server/User/settings.json \
mcolebrook/code-con
```


## Running Visual Studio Code

```
vscode.sh
```

## Running CDR code-server

```
code-server.sh
```

## Screenshots

- Visual Studio Code debugging `helloworld`

- code-server running `helloworld`

## Cite as

```
@software{Colebrook_code-con_2021,
title = {{code-con: a Docker image of VS Code and CDR code-server}},
author = {Colebrook, Marcos},
year = {2021}
url = {https://github.com/mcolebrook/code-con}
}
```

## Acknowledgements
This work has been developed within project UDIGEN, grant RTC-2017-6471-1 funded by MCIN/AEI/10.13039/501100011033 and by “ERDF A way of making Europe”.
![MCIN/AEI/ERDF](_figures/MCIN_AEI.jpg)

Refer to all previous projects... (see webpages and Githubs)
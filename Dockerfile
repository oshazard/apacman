FROM vcatechnology/arch-ci:latest
MAINTAINER oshazard
RUN sudo pacman -Syu
RUN sudo pacman -S jshon bash-bats --needed --asdeps --noconfirm
RUN sudo curl -O "https://raw.githubusercontent.com/oshazard/apacman/master/apacman"
RUN sudo bash ./apacman -S apacman --noconfirm
RUN sudo apacman -S apacman-deps proot fuse --needed --asdeps --noconfirm

# docker build -t "apacman:dockerfile" .
# docker run -t -i "apacman:dockerfile" bats /usr/share/bats/apacman.bats

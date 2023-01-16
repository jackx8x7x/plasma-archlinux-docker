# update all packages and the Pacman mirrorlist
RUN pacman -Syu; \
pacman -S --noconfirm reflector; \
reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist;

# install the desktop environment
RUN pacman -S --noconfirm xorg-server plasma-desktop plasma-wayland-session;

# install the VNC and noVNC server
WORKDIR /opt/
RUN pacman -S --noconfirm git tigervnc; \
git clone https://github.com/novnc/noVNC; \
Xvnc

# start the novnc
CMD ["/opt/utils/novnc_proxy", "--vnc", "localhost:5900"]

# expose port used by noVNC
EXPOSE 6080/tcp

FROM archlinux:latest

# update all packages and the Pacman mirrorlist
RUN pacman -Sy; \
pacman -S --noconfirm reflector; \
reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# install the desktop environment
RUN pacman -S --noconfirm --disable-download-timeout xorg-server plasma-desktop

# install the VNC and noVNC server
WORKDIR /opt/
RUN pacman -S --noconfirm --disable-download-timeout git tigervnc supervisor; \
git clone https://github.com/novnc/noVNC

# vnc configuration
WORKDIR /root/.vnc
RUN vncpasswd -f <<< "123456" > passwd && chmod 600 passwd
COPY xstartup .
RUN chmod +x xstartup

# start the novnc and tigervnc via supervisor
WORKDIR /root
COPY supervisor.ini /etc/supervisor.d/supervisor.ini
CMD ["/usr/bin/supervisord"]

# expose port used by noVNC
EXPOSE 6080/tcp

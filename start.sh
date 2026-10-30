
#!/bin/bash
set -e

export DISPLAY=:0

Xvfb :0 -screen 0 1280x800x24 &
sleep 2

fluxbox &

mkdir -p /root/.vnc
x11vnc -storepasswd "$VNC_PASSWORD" /root/.vnc/passwd

x11vnc -display :0 \
    -forever \
    -shared \
    -rfbauth /root/.vnc/passwd \
    -rfbport 5900 &

websockify --web=/usr/share/novnc/ 0.0.0.0:10000 localhost:5900 &

sleep 2

python ET.py

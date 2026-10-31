#!/bin/bash
set -e

export DISPLAY=:0
PORT="${PORT:-10000}"

if [ -z "$VNC_PASSWORD" ]; then
    echo "VNC_PASSWORD is missing"
    exit 1
fi

mkdir -p /root/.vnc

x11vnc -storepasswd "$VNC_PASSWORD" /root/.vnc/passwd

Xvfb :0 -screen 0 1280x800x24 &
sleep 2

fluxbox -no-slit &

x11vnc -display :0 \
    -forever \
    -shared \
    -localhost \
    -rfbauth /root/.vnc/passwd \
    -noxdamage \
    -noxfixes \
    -noxdamage \
    -noxfixes \
    -rfbport 5900 &

cat > /usr/share/novnc/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="0; url=/vnc.html?autoconnect=true">
    <title>Expense Tracker</title>
</head>
<body>
    Redirecting to Expense Tracker...
</body>
</html>
EOF

websockify --web=/usr/share/novnc/ \
    0.0.0.0:$PORT localhost:5900 &

sleep 2

exec python ET.py

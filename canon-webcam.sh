#!/bin/bash
# Canon 1300D webcam stream only

if ! lsmod | grep -q v4l2loopback; then
  sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2 card_label=CanonWebcam
fi

DEV=$(grep -l "CanonWebcam" /sys/devices/virtual/video4linux/*/name | head -n1 | xargs dirname | xargs basename)
DEV="/dev/$DEV"

pkill -f gvfs-gphoto2-volume-monitor 2>/dev/null
pkill -f gvfsd-gphoto2 2>/dev/null

notify-send "Canon Webcam" "Streaming on $DEV"

gphoto2 --stdout --capture-movie | \
  ffmpeg -loglevel error -i - -vf format=yuv420p -f v4l2 "$DEV"

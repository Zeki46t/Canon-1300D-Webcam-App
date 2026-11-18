#!/bin/bash
# Preview window for the Canon virtual webcam

DEV=$(grep -l "CanonWebcam" /sys/devices/virtual/video4linux/*/name 2>/dev/null | head -n1 | xargs -r dirname | xargs -r basename)

if [ -z "$DEV" ]; then
  notify-send "Canon Preview" "Virtual camera not found. Start Canon Webcam first."
  exit 1
fi

ffplay -loglevel error -fflags nobuffer -flags low_delay \
  -window_title "Canon Preview" -x 480 -alwaysontop "/dev/$DEV"

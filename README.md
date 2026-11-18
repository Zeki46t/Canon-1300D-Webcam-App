# Canon 1300D Webcam App

One-click launchers that turn a Canon EOS 1300D (Rebel T6) into a webcam on Linux (tested on Pop!_OS). It uses `gphoto2` to read the camera's live view, `ffmpeg` to convert it, and `v4l2loopback` to expose it as a virtual webcam that Zoom, Meet, OBS and other apps can use.

## Files

| File | Purpose |
|------|---------|
| `canon-webcam.sh` | Loads the virtual camera and starts the stream |
| `canon-preview.sh` | Opens a small always-on-top preview window |
| `canon-webcam.desktop` | App launcher for the stream |
| `canon-preview.desktop` | App launcher for the preview |

Closing the preview does not stop the stream.

## Setup

### 1. Install packages

```bash
sudo apt install gphoto2 v4l2loopback-utils v4l2loopback-dkms ffmpeg libnotify-bin
```

### 2. Install the scripts

Copy the scripts to your home folder and make them executable:

```bash
cp canon-webcam.sh canon-preview.sh ~/
chmod +x ~/canon-webcam.sh ~/canon-preview.sh
```

### 3. Allow loading the virtual camera without a password (optional)

```bash
sudo visudo -f /etc/sudoers.d/canon-webcam
```

Add this line, replacing `yourusername`. Check your modprobe path with `which modprobe` (often `/usr/sbin/modprobe`) and use that path:

```
yourusername ALL=(root) NOPASSWD: /sbin/modprobe v4l2loopback exclusive_caps=1 max_buffers=2 card_label=CanonWebcam
```

The label must be a single word, because sudoers splits arguments on spaces.

### 4. Add the app launchers

Edit both `.desktop` files and replace `yourusername` with your Linux username, then:

```bash
cp canon-webcam.desktop canon-preview.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/canon-webcam.desktop ~/.local/share/applications/canon-preview.desktop
```

Search for **Canon Webcam** and **Canon Preview** in your app launcher.

## Usage

1. Connect the camera over USB and turn it on. Turn off Wi-Fi on the camera.
2. Start **Canon Webcam** and wait a few seconds.
3. Optionally open **Canon Preview** to check your framing.
4. Pick **CanonWebcam** as the camera in your video app.

## Troubleshooting

- **Preview says the virtual camera was not found:** the stream is not running yet, or the module was loaded earlier under a different label. Reset it:
  ```bash
  pkill gphoto2
  sudo modprobe -r v4l2loopback
  ~/canon-webcam.sh
  ```
- **Black preview:** the camera may need longer to start, or it went to sleep. Touch the shutter button and restart the stream.
- **`notify-send: command not found`:** install `libnotify-bin`.
- **`No camera found`:** make sure camera Wi-Fi is off and nothing else has mounted or claimed the camera.
- Run the scripts from a terminal to see error output.

## Notes

- Live view on the 1300D is fairly low resolution, so good lighting helps more than any setting.
- For long sessions, use a dummy battery (AC adapter) so the camera does not run out of power.

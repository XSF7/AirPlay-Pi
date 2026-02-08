# Config – Orange Pi PC Audio Setup (ALSA) + Duplicate Output

This folder contains the documentation page for configuring ALSA on **Orange Pi PC** to output sound to **Analog (Line-out)** and **HDMI** at the same time.

---

## Files

- `audio-setup.html`  
  A standalone HTML documentation page (dark theme) that explains:
  - Unmuting **Audio lineout** in `alsamixer`
  - Saving mixer state with `alsactl`
  - Checking sound devices (`arecord -l`, `aplay -l`)
  - Setting up `/etc/asound.conf` to duplicate audio to **Analog + HDMI**
  - Testing audio with `speaker-test`

---

## How to add the HTML file in this folder

From your repository root:

```bash
mkdir -p Config
nano Config/audio-setup.html

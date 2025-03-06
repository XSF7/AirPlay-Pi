# AirPlay-Pi

## AirPlay on Orange Pi Zero

### Project Overview

The **AirPlay-Pi** project transforms an Orange Pi Zero into an AirPlay receiver using **Shairport Sync**. This allows you to stream audio from Apple devices or any AirPlay-enabled device directly to your Orange Pi Zero, making it an affordable and versatile audio receiver.

### Key Features

- **Auto Start on Boot:** The service is configured to run automatically when the Orange Pi Zero is powered on.
- **Stable AirPlay Service:** Uses Shairport Sync, providing robust AirPlay support.
- **Service Management:** Simple commands to start, stop, and check the status of the AirPlay service.

## Getting Started

### Hardware Requirements

- Orange Pi Zero (256MB/512MB)
- External Audio Output (e.g., USB sound card, HDMI, or 3.5mm audio jack)
- Power Supply (5V, 2A recommended)

### Software Requirements

- Shairport Sync
- Armbian OS (or any compatible OS for Orange Pi Zero)
- Terminal access (SSH or directly connected)

### Installation Steps

1. **Update and Upgrade System:**

```bash
sudo apt update && sudo apt upgrade
```

2. **Install Shairport Sync:**

```bash
sudo apt install shairport-sync
```

3. **Enable Shairport Sync on Boot:**

```bash
sudo systemctl enable shairport-sync
```

4. **Start the AirPlay Service:**

```bash
sudo service shairport-sync start
```

5. **Check Service Status:**

```bash
sudo systemctl status shairport-sync.service
```

## Verifying the Setup

- **On your AirPlay-enabled device:** Look for the Orange Pi in the AirPlay device list.
- **Audio Output:** Connect a speaker to the Orange Pi and test by playing audio through AirPlay.

## Troubleshooting

- **No AirPlay device found:** Make sure Shairport Sync is running (`sudo systemctl status shairport-sync`).
- **Audio issues:** Check audio output configuration and try restarting the service.

## Additional Resources

- [Shairport Sync Documentation](https://github.com/mikebrady/shairport-sync)
- [Orange Pi Zero Setup Guide](http://auseparts.com.au/image/cache/catalog/OrangePi/ExBoard/OPEx%20board1-700x700.jpg)

---

Feel free to contribute to this project or ask questions via the GitHub repository!

![alt text](https://www.robotistan.com/orange-pi-zero-256mb-board-18295-64-B.jpg)

# A Docker BLE Cycling Power Service for the WaterRower S4

This docker container simplifies running `olympum/waterrower-ble` on a Raspberry Pi 3 (B+).

The objective of this adapter is to expose the WaterRower S4, an indoor rowing "erg", as a Bluetooth Low Energy Cycling Power Service peripheral. The BLE sensor exposes power and stroke rate data, which makes it suitable for using the WaterRower in applications like Zwift, or simply to just record the power, cadence and heart rate data, e.g. in the Wahoo Fitness app.

You can visit the [olympum/waterrower-ble](https://github.com/olympum/waterrower-ble) GitHub site for more information.

## Installation on the Raspberry Pi 3 (B+) ##

These instructions are specific to the Raspberry Pi 3 (B+) with Raspbian Stretch (Lite/Full).

I am assuming throughout that you are running as `pi:pi` and have `sudo` privileges.

First let's make sure we are up to date:

```
$ sudo apt-get update -y
$ sudo apt-get upgrade -y
$ sudo rpi-update
$ sudo reboot
```

Install docker on your Raspberry Pi 3 (B+):

```
$ curl -sSL https://get.docker.com | sh
```

Now let's run the docker waterrower-ble container. The docker image will be downloaded automatically if it cannot be found locally. The container will run in privileged mode to enable access to all devices on the host (i.e. WaterRower S4 USB). In addition, it makes use of the host's network for passing through the Bluetooth Low Energy device (which is a network device).

```
$ sudo docker run --restart=always --privileged --network host --name waterrower-ble -d databreach/waterrower-ble
```

Done! We are ready to row.

## Rowing with Power

Now we are ready to start a good workout on the erg. Once installed on the Raspberry Pi 3 (B+), the sequence to get up and running is the following:

1. Connect the WaterRower S4 USB cable to the Raspberry Pi 3 (B+).
1. Switch on the WaterRower S4. You should hear a beep.
1. Switch on the Raspberry Pi 3 (B+). You should hear another beep.
1. On a device with BLE, e.g. iPhone, pair to the "WaterRower S4" sensor using your favorite app (e.g. Wahoo Fitness).
1. Once done rowing, switch off the WaterRower S4 and/or unplug the USB cable from the Raspberry Pi 3 (B+). Otherwise the WaterRower S4 monitor will not power off.

## Rowing on Zwift

1. Open the Zwift mobile app, e.g. for iOS.
1. On the computer, open the Zwift app.
1. Once you are signed into Zwift, you should see the pairing sensor screen. The bluetooth phone next to the ANT+ sign should be pulsing. If it has a yellow warning or if it's greyed out, ensure your phone is on the same Wi-Fi network as the computer and reset bluetooth (switch bluetooth off and back on again).
1. Find and pair the heart rate monitor, the power meter and the cadence sensors called "WaterRower S4". Sometimes the sensors will named after the computer where the WaterRower is connected to.
1. Start rowing and enjoy the workout.

**Note:** The WaterRower BLE sensor does not work when connecting the WaterRower S4 USB cable after switching on the Raspberry Pi 3 (B+) and/or after resetting the WaterRower S4 monitor when already connected to the Raspberry Pi 3 (B+).


Happy Rowing!

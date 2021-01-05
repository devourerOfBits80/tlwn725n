# tlwn725n (Wireless N Nano USB Adapter)

A simple *Bash* script to establish a *Wi-Fi* connection for the *TP-LINK TL-WN725N (USB)* device. Intended for the *[Arch Linux](https://www.archlinux.org/)* OS and all distributions based on it.

## Installation

Clone the *tlwn725n* repository to a *USB flash drive* or to any different portable mass storage device.

> \$ git clone <https://github.com/devourerOfBits80/tlwn725n.git> /run/media/{user}/{device_identifier}

## Usage

Boot the live environment using an OS installation media, plug-in the prepared *USB flash drive* to a *USB* port, and mount it to the */mnt*.

> \$ mount /dev/sd*XY* /mnt (to list all block devices use a command *lsblk -l*)

Go to the *tlwn725n* script directory, list available network interfaces, find out the proper one, and execute the *Wi-Fi* connection script.

> \$ cd /mnt/tlwn725n  
> \$ ip link (the expected interface name should be *wlan0* or something similar)  
> \$ ./tlwn725n.sh -i *wlan0* -s {SSID} -p {PASSWORD} -c PL (-c, country code is optional, default set to *US*, Poland in this case)

You should be able to access the internet now. The *[wpa_supplicant](https://wiki.archlinux.org/index.php/wpa_supplicant)* configuration file can be found in the */etc/wpa_supplicant* directory. Its name should look like: *wpa_supplicant-wext-wlan0.conf*.

Finally, unmount the device.

> \$ umount /mnt

voilà

#!/bin/bash

case $1 in
    help)
        echo "tlwn725n: A simple script to establish a Wi-Fi connection
          for the TP-LINK TL-WN725N (USB) device.

Usage: ./tlwn725n.sh -i {INTERFACE} -s {SSID} -p {PASSWORD} [-c {COUNTRY_CODE}]
Parameters:
    -i: TL-WN725N device interface (eg. wlan0) [mandatory]
    -s: SSID of the wireless network [mandatory]
    -p: passphrase to the wireless network [mandatory]
    -c: ISO/IEC alpha2 country code in which the device is operating
        (default US) [optional]"
        exit ;;
esac

while getopts i:s:p:c: flag; do
    case "${flag}" in
        i) INTERFACE=${OPTARG} ;;
        s) SSID=${OPTARG} ;;
        p) PASSWORD=${OPTARG} ;;
        c) COUNTRY_CODE=${OPTARG} ;;
    esac
done

if [ ! $INTERFACE ]; then
    echo "-i (INTERFACE) parameter has to be provided";
    exit;
fi

if [ ! $SSID ]; then
    echo "-s (SSID) parameter has to be provided";
    exit;
fi

if [ ! $PASSWORD ]; then
    echo "-p (PASSWORD) parameter has to be provided";
    exit;
else
    PASSWORD_SIZE=${#PASSWORD}
fi

if ((($PASSWORD_SIZE < 8) || ($PASSWORD_SIZE > 63))); then
    echo "passphrase must be 8..63 characters";
    exit;
fi

WPA_SUPPLICANT_TEMP_CONF="./wpa_supplicant-template.conf"
WPA_SUPPLICANT_CONF="/etc/wpa_supplicant/wpa_supplicant-wext-$INTERFACE.conf"

if [ -f "$WPA_SUPPLICANT_CONF" ]; then
    rm -f $WPA_SUPPLICANT_CONF
fi

cp -f $WPA_SUPPLICANT_TEMP_CONF $WPA_SUPPLICANT_CONF

if [ $COUNTRY_CODE ]; then
    sed -i 's/^country=.*/country='$COUNTRY_CODE'/' $WPA_SUPPLICANT_CONF
fi

/usr/bin/wpa_passphrase $SSID $PASSWORD >> $WPA_SUPPLICANT_CONF
/usr/bin/wpa_supplicant -B -D wext -i $INTERFACE -c $WPA_SUPPLICANT_CONF
/usr/bin/dhcpcd $INTERFACE

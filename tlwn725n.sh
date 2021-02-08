#!/bin/bash

case $1 in
    help)
        echo "
tlwn725n.sh - simple script to establish a Wi-Fi connection for the TP-LINK
TL-WN725N USB 2.0 Wi-Fi adapter

Usage:
    ./tlwn725n.sh -i {INTERFACE} -s {SSID} -p {PASSWORD} [-c {COUNTRY_CODE}]

Parameters:
    {INTERFACE}     - TL-WN725N device interface (eg. wlan0) [mandatory]
    {SSID}          - SSID of the wireless network you want to connect to
                      [mandatory]
    {PASSWORD}      - passphrase to the wireless network [mandatory]
    {COUNTRY_CODE}  - ISO/IEC alpha2 country code in which the device is
                      operating (default US) [optional]
"
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
    echo "the {INTERFACE} parameter has to be provided";
    exit
fi

if [ ! $SSID ]; then
    echo "the {SSID} parameter has to be provided";
    exit
fi

if [ ! $PASSWORD ]; then
    echo "the {PASSWORD} parameter has to be provided";
    exit
else
    PASSWORD_SIZE=${#PASSWORD}

    if [[ "$PASSWORD_SIZE" -lt 8 || "$PASSWORD_SIZE" -gt 63 ]]; then
        echo "passphrase must be 8..63 characters";
        exit
    fi
fi

TEMPLATE_CONF_FILE="./template.conf"
WPA_SUPPLICANT_CONF_FILE="/etc/wpa_supplicant/wpa_supplicant-wext-$INTERFACE.conf"

if [ -f "$WPA_SUPPLICANT_CONF_FILE" ]; then
    rm -f $WPA_SUPPLICANT_CONF_FILE
fi

cp $TEMPLATE_CONF_FILE $WPA_SUPPLICANT_CONF_FILE

if [ $COUNTRY_CODE ]; then
    sed -i 's/^country=.*/country='$COUNTRY_CODE'/' $WPA_SUPPLICANT_CONF_FILE
fi

/usr/bin/wpa_passphrase $SSID $PASSWORD >> $WPA_SUPPLICANT_CONF_FILE
/usr/bin/wpa_supplicant -B -D wext -i $INTERFACE -c $WPA_SUPPLICANT_CONF_FILE
/usr/bin/dhcpcd $INTERFACE

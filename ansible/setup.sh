#!/usr/bin/env bash

virtualization=$(systemd-detect-virt)

if [ "$virtualization" != "none" ]; then
    echo "Sorry, but $(hostname) is virtualized with $virtualization."
    echo "If you want to use Vagrant go to a baremetal host."
    exit 1
fi

echo "--- Setup Vagrant ---"
vagrant up
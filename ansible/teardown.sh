#!/usr/bin/env bash

ports=(2222)

echo "--- Destroy Vagrant machines ---"
vagrant destroy -f
vagrant global-status --prune

echo "--- Clean Vagrant keys ---"
for port in "${ports[@]}"; do
    ssh-keygen -f "/home/xpuser/.ssh/known_hosts" -R "[localhost]:${port}"
done

echo "--- Check listening port. If any execute command: kill -9 PID ---"
for port in "${ports[@]}"; do
    sudo ss -ltnp | grep ":${port}"
done

echo "--- Clean Vagrant files ---"
rm -rf ".vagrant"
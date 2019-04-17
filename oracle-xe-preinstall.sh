#!/bin/bash

set -e # Exit script immediately on first error.
set -x # Print commands and their arguments as they are executed.

CURRENT_TIMEZONE='America/Fortaleza'

# Updates locales
sudo apt-get install locales -y

# Configures timezone
echo "$CURRENT_TIMEZONE" | sudo tee /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata

# Configures locale as pt_BR and encoding as ISO-8859-1
sudo locale-gen pt_BR
sudo locale-gen pt_BR.ISO-8859-1 || true 
sudo update-locale LANG=pt_BR.ISO-8859-1 LC_MESSAGES=POSIX 
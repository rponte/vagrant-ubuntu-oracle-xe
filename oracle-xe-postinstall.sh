#!/bin/bash

set -e # Exit script immediately on first error.
set -x # Print commands and their arguments as they are executed.

# Tuning Oracle 11G XE
echo "ALTER SYSTEM SET processes=200 scope=spfile;" | sqlplus -s SYSTEM/manager
echo "ALTER SYSTEM SET FILESYSTEMIO_OPTIONS=ASYNCH SCOPE=SPFILE;" | sqlplus -s SYSTEM/manager
echo "ALTER SYSTEM SET disk_asynch_io=TRUE SCOPE=SPFILE;" | sqlplus -s SYSTEM/manager
sudo service oracle-xe restart

# Enables console color
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc

# Installs extra packages and tools
sudo apt-get install htop -y

# Cleaning unneeded packages
sudo apt-get autoremove -y
sudo apt-get clean 
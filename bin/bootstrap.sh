#! /bin/bash

# Copyright (c) 2014, Emanuele Palazzetti and contributors
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# The views and conclusions contained in the software and documentation are those
# of the authors and should not be interpreted as representing official policies,
# either expressed or implied, of the FreeBSD Project.

set -e

### Variables
ROOT_FOLDER=/root/hanzo/
REPOSITORY=https://github.com/palazzem/hanzo.git
DATA_STORE=/root/.hanzo

### Retrieving installation parameters

if [ ! -f "$DATA_STORE" ]; then
    # we don't have a previous run, so ask for developer's data...
    read -p "Provide your full name: " FULLNAME
    read -p "Provide your username: " USERNAME
    read -p "Provide your email: " EMAIL

    # ...and save them for the next run
    echo "export FULLNAME=$FULLNAME" > $DATA_STORE
    echo "export USERNAME=$USERNAME" >> $DATA_STORE
    echo "export EMAIL=$EMAIL" >> $DATA_STORE
else
    # this is not the first time so we may load the content
    # from the file
    source "$DATA_STORE"
fi

### System update and dependencies
echo "Updating the system..."
pacman -Syu --noconfirm

echo "Installing dependencies..."
pacman -S ansible git --noconfirm

echo "Cloning ansible-devel repository..."
if [ ! -d "$ROOT_FOLDER" ]; then
    git clone "$REPOSITORY" "$ROOT_FOLDER"
    cd "$ROOT_FOLDER"
else
    cd "$ROOT_FOLDER"
    git pull
fi

### The Orchestration
echo "Starting orchestration..."
ansible-playbook orchestrate.yml -i inventory --connection=local -e "fullname='$FULLNAME' email=$EMAIL username=$USERNAME"

### Last messages
echo "Configuration completed!"
echo "You can also install the following packages:"
echo
echo "    # browsers"
echo "    $ yaourt -S firefox-developer google-chrome"
echo
echo "    # window manager"
echo "    $ yaourt -S archey3 xdo-git lemonbar-xft-git"
echo
echo "    # terminal"
echo "    $ yaourt -S rxvt-unicode-256xresources urxvt-perls urxvt-resize-font-git urxvt-vtwheel"
echo
echo "    # fonts"
echo "    $ yaourt -S ttf-ms-fonts ttf-font-awesome infinality-bundle"
echo
echo "    # Android"
echo "    $ yaourt -S gradle android-sdk android-sdk-platform-tools android-sdk-build-tools android-platform"
echo "    $ yaourt -S --tmp ~/ android-ndk"
echo
echo "    # generic stuff"
echo "    $ yaourt -S downgrade blueman"
echo "    $ yaourt -S mbpfan-git # (optional for Macbook laptops)"
echo
echo "Bear in mind, the following command is **mandatory**:"
echo "$ passwd $USERNAME"

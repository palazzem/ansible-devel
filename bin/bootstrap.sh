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
ROOT_FOLDER=/root/ansible-devel/
REPOSITORY=https://github.com/palazzem/ansible-devel.git

### Requiring environment variables
read -p "Provide your full name: " FULLNAME
read -p "Provide your username: " USERNAME
read -p "Provide your email: " EMAIL

# Installing dependencies
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

# Proceeding with orchestration
echo "Starting orchestration..."
ansible-playbook orchestrate.yml -i inventory --connection=local -e "fullname='$FULLNAME' email=$EMAIL username=$USERNAME"

echo "Configuration completed!"
echo "The following command is *mandatory*:"
echo "$ passwd $USERNAME"

echo ""
echo "You can also install the following packages:"
echo "$ yaourt -S firefox-developer google-chrome"
echo "$ yaourt -S awesome-themes-git"
echo "$ yaourt -S downgrade"
echo "$ yaourt -S ttf-ms-fonts"
echo "$ yaourt -S watchman"
echo "$ yaourt -S mbpfan-git # (optional for Macbook laptops)"

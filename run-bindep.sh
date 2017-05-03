#!/usr/bin/env bash
# Copyright 2017, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Get a list of packages to install with bindep. If packages need to be
# installed, bindep exits with an exit code of 1.
BINDEP_PKGS=$(bindep -b -f ${BINDEP_FILE:-bindep.txt} test || true)
echo "Packages to install: ${BINDEP_PKGS}"

# Install a list of OS packages provided by bindep.
if which apt-get; then
    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive \
      sudo apt-get -q --option "Dpkg::Options::=--force-confold" \
      --assume-yes install $BINDEP_PKGS
elif which yum; then
    # Don't run yum with an empty list of packages.
    # It will fail and cause the script to exit with an error.
    if [[ ${#BINDEP_PKGS} > 0 ]]; then
      sudo yum install -y $BINDEP_PKGS
    fi
fi


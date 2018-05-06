#!/bin/bash
# update-roles.sh
grep 'name:' requirements.yml | awk -F: '{print $2}' | xargs -I {} sudo ansible-galaxy remove {}
sudo ansible-galaxy install -r requirements.yml

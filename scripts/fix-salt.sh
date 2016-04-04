#!/usr/bin/env bash

# run as cloud-user

rm -rf /srv/pillar
rm -rf /srv/salt
chmod 777 /srv

git clone git@github.com:eshbaugh/OC-SaltMaster.git /srv/salt
git clone git@github.com:eshbaugh/OC-SaltPillar.git /srv/pillar
chown -R cloud-user.cloud-user /srv
cd /srv/pillar
git checkout JerryDev 


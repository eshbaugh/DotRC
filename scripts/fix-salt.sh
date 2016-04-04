#!/usr/bin/env bash
# run as root

rm -rf /srv/pillar
rm -rf /srv/salt
chmod 777 /srv

git clone git@github.com:eshbaugh/OC-SaltMaster.git /srv/salt
git clone git@github.com:eshbaugh/OC-SaltPillar.git /srv/pillar
chown -R cloud-user.cloud-user /srv

cd /srv/pillar
git checkout JerryDev 
git pull

cd /srv/salt
git pull

cd /home/cloud-user/DotRC
git pull

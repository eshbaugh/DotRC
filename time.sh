#!/usr/bin/env bash

date
salt -G 'role:web' state.apply cloud-backup/backup
date


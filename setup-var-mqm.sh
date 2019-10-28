#!/bin/bash

find /mnt /var /etc -group 1000 | xargs chgrp 999
find /mnt /var /etc -user 1000 | xargs chown 999

if [ -d "/var/mqm/qmgrs" ]; then
  # User is probably following old instructions to mount a volume into /var/mqm
  echo "Using existing MQ Data under /var/mqm"
  /opt/mqm/bin/crtmqdir -a -f
else
  if [ -L "/var/mqm" ]; then
    echo "/var/mqm is already a symlink."
    /opt/mqm/bin/crtmqdir -a -f
  else
    if [ -d "/mnt/mqm/" ]; then
      DATA_DIR=/mnt/mqm/data
      MOUNT_DIR=/mnt/mqm
      echo "Symlinking /var/mqm to $DATA_DIR"

      # Add mqm to the root user group and add group permissions to mount directory
      usermod -aG root mqm
      chmod 775 ${MOUNT_DIR}

      if [ ! -e ${DATA_DIR} ]; then
        mkdir -p ${DATA_DIR}
        chown mqm:mqm ${DATA_DIR}
        chmod 775 ${DATA_DIR}
      fi

      /opt/mqm/bin/crtmqdir -a -f
      su -c "cp -RTnv /var/mqm /mnt/mqm/data" -l mqm

      # Remove /var/mqm and replace with a symlink
      rm -rf /var/mqm
      ln -s ${DATA_DIR} /var/mqm
      chown -h mqm:mqm /var/mqm
    else
      # Create the MQ data Directory
      /opt/mqm/bin/crtmqdir -a -f
    fi
  fi
fi

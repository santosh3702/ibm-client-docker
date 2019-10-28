#!/bin/bash

set -e
mq-license-check.sh
echo "----------------------------------------"
setup-var-mqm.sh
echo "----------------------------------------"
mq-configure-qmgr.sh
echo "----------------------------------------"
exec mq-monitor-qmgr.sh

#!/bin/bash

state()
{
  dspmqinst | grep "State:" | awk '{ print $2 }'
}

echo "Monitoring IBM MQ Client"

# Loop until "dspmqinst" says the MQ Client is running
until [ "`state`" == "Available" ]; do
  sleep 1
done
dspmqinst

echo "IBM MQ Client is now fully running"

# Loop until "dspmqinst" says the client is not running any more
until [ "`state`" != "Available" ]; do
  sleep 5
done

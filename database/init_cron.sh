#!/bin/sh

echo "0 4 * * * backup 'scheduled update'" >> /etc/crontabs/root
/usr/sbin/crond


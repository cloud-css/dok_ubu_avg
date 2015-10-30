#!/bin/bash
/etc/init.d/avgd start > /dev/null 2>&1 && cd /var/www && nodejs index.js
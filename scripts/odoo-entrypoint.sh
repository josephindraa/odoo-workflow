#!/bin/sh
set -e

BASE_CONF="/etc/odoo/odoo.conf"
LOCAL_CONF="/etc/odoo/local.conf"

# Verify the existence of local.conf
if [ ! -f "$LOCAL_CONF" ]; then
    echo "========================================================================"
    echo " [ERROR] 'local.conf' file not found!"
    echo "========================================================================"
    echo " Please create and fill in the 'config/local.conf' file manually."
    echo " You can copy the template from 'config/local.conf.example'."
    echo ""
    echo " Command to create manually:"
    echo "   cp config/odoo/local.conf.example config/odoo/local.conf"
    echo ""
    echo " Once the file is created and values are configured, restart the container."
    echo "========================================================================"
    exit 1
fi

# Merge & run odoo config
python3 -c "
import configparser
config = configparser.ConfigParser()
config.read(['$BASE_CONF', '$LOCAL_CONF'])
with open('/tmp/odoo_merged.conf', 'w') as f:
    config.write(f)
"
exec odoo -c /tmp/odoo_merged.conf "$@"

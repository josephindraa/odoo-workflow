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

# Run Odoo if local.conf exists
echo "Loading base configuration ($BASE_CONF) with override ($LOCAL_CONF)..."
exec odoo -c "$BASE_CONF" -c "$LOCAL_CONF" "$@"

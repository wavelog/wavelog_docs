# Maintenance Mode

Wavelog brings with version 1.2 a maintenance mode.

The maintenance mode allows to block normal user logins (User Level: 'Operator'). Only Administrators can login normally if the maintenance mode is enabled.

## How to enable the maintenance mode

Just create a file in the root directory called `.maintenance`

Example for Debian Servers:

    cd /var/www/wavelog
    touch .maintenance
    
To disabled the maintenance mode just remove the file:

    cd /var/www/wavelog
    rm .maintenance 

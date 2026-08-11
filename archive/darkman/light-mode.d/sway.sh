#!/usr/bin/env bash

cat <<'EOF' >~/.config/sway/config.d/90-sway-colors.conf
# class                 border  background text    indicator child_border
client.focused          #076678 #fbf1c7    #3c3836 #79740e   #458588
client.focused_inactive #3c3836 #665c54    #fbf1c7 #504945   #665c54
client.unfocused        #3c3836 #282828    #fbf1c7 #7c6f64   #282828
client.urgent           #282828 #9d0006    #fbf1c7 #cc241d   #9d0006
EOF

sway reload

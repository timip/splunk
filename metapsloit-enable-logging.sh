#!/bin/bash

for home_dir in /root /home/*; do

    echo $home_dir

    home_dir_user=$(stat -c '%U' $home_dir)
    home_dir_group=$(stat -c '%G' $home_dir)

    if [ ! -d $home_dir/.msf4 ]; then
       mkdir -p $home_dir/.msf4
       chown $home_dir_user:$home_dir_group $home_dir/.msf4
    fi

    cat << EOF > $home_dir/.msf4/config
[framework/core]
ConsoleLogging=true
SessionLogging=true
EOF
    chown $home_dir_user:$home_dir_group /home/$home_dir_user/.msf4/config

    echo "(+) Enabled Metasploit logging for $home_dir_user"

done

